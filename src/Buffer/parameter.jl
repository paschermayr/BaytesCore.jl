############################################################################################
"""
$(SIGNATURES)
Stores a vector of a  single model parameter `val` and its current index `index` in the chain.

# Examples
```julia
```

"""
struct ParameterBuffer{M, I<:Integer}
    "Model parameter."
    val::Vector{M}
    "Indices for model parameter in the chain."
    index::Vector{I}
end
function ParameterBuffer(
    val::AbstractVector{T},
    Nparameter::Integer,
    F::Type{I}) where {T, I<:Integer}
    return ParameterBuffer{T, I}(
        typeof(val)(undef, Nparameter),
        F.(1:Nparameter)
    )
end
function ParameterBuffer(
    val::T,
    Nparameter::Integer,
    F::Type{I}) where {T, I<:Integer}
    return ParameterBuffer{T, I}(
        Vector{typeof(val)}(undef, Nparameter),
        F.(1:Nparameter)
    )
end

function resize!(buffer::ParameterBuffer, Nparameter::Integer)
    resize!(buffer.val, Nparameter)
    resize!(buffer.index, Nparameter)
    return nothing
end

function shuffle!(
    buffer::ParameterBuffer,
    val::AbstractVector{A},
    ) where {A}
    ## Shuffle Model parameter
    @inbounds for idx in Base.OneTo(length(buffer.val))
        buffer.val[idx] = val[buffer.index[idx]]
    end
    ## Return back to appropriate place
    #!NOTE: Cannot be performed in same loop as before
    @inbounds for idx in Base.OneTo(length(buffer.val))
        val[idx] = buffer.val[idx]
    end
    return nothing
end

############################################################################################
"""
$(SIGNATURES)
Stores a vector of a all model parameter `val` and several useful location statistics in the chain.

# Examples
```julia
```

"""
struct ModelParameterBuffer{M<:NamedTuple, I<:Integer, L, T<:AbstractFloat}
    "Model parameter."
    val::Vector{M}
    "Indices for model parameter in the chain."
    index::Vector{I}
    "LogDensity results."
    result::Vector{L}
    "Stores Weight of val used for resampling `val`."
    weight::Vector{T}
    function ModelParameterBuffer(
        val::Vector{M},
        index::Vector{I},
        result::Vector{L},
        weight::Vector{T}
        ) where {M<:NamedTuple, I<:Integer, L, T<:AbstractFloat}
        return new{M, I, L, T}(val, index, result, weight)
    end
end

function ModelParameterBuffer(
    model::M,
    result::R,
    Nparameter::Integer,
    F::Type{I}
    ) where {M<:AbstractModelWrapper, R<:AbstractResult, I<:Integer}
    val = Vector{typeof(model.val)}(undef, Nparameter)
    result = Vector{typeof(result)}(undef, Nparameter)
    index = F.(1:Nparameter)
    weight = zeros(Nparameter)
    return ModelParameterBuffer(val, index, result, weight)
end

function resize!(buffer::ModelParameterBuffer, Nparameter::Integer)
    resize!(buffer.val, Nparameter)
    resize!(buffer.index, Nparameter)
    resize!(buffer.result, Nparameter)
    resize!(buffer.weight, Nparameter)
    return nothing
end

function shuffle!(
    buffer::ModelParameterBuffer,
    algorithm::AbstractVector{A},
    model::AbstractVector{M}
    ) where {A<:AbstractAlgorithm, M<:AbstractModelWrapper}
    ## Shuffle Model parameter and log objective results
    @inbounds for idx in Base.OneTo(length(buffer.val))
        buffer.val[idx] = model[buffer.index[idx]].val
        buffer.result[idx] = get_result(algorithm[buffer.index[idx]])
    end
    ## Return back to appropriate place
    #!NOTE: Cannot be performed in same loop as before
    @inbounds for idx in Base.OneTo(length(buffer.val))
        model[idx].val = buffer.val[idx]
        result!(algorithm[idx], buffer.result[idx])
        #!NOTE: Cannot switch from get_loglik to result.ll because sampler treats ll differently
        buffer.weight[idx] = get_loglik(algorithm[idx])
    end
    return nothing
end

############################################################################################
# Export
export
    ParameterBuffer,
    ModelParameterBuffer,
    shuffle!
