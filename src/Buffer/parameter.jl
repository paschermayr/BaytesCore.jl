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
    #!NOTE: This contains only Particle Filter Particles, not full Model Parameter. Hence iterating over particle elements will not cause pointer issues (unlike ModelParameterBuffer)
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
struct ModelParameterBuffer{M<:NamedTuple, I<:Integer, T<:AbstractFloat}
    "Model parameter."
    val::Vector{M}
    "Indices for model parameter in the chain."
    index::Vector{I}
    "Stores Weight of val used for resampling `val`."
    weight::Vector{T}
    function ModelParameterBuffer(
        val::Vector{M},
        index::Vector{I},
        weight::Vector{T}
        ) where {M<:NamedTuple, I<:Integer, T<:AbstractFloat}
        return new{M, I, T}(val, index, weight)
    end
end

function ModelParameterBuffer(
    model::M,
    Nparameter::Integer,
    F::Type{I}
    ) where {M<:AbstractModelWrapper, I<:Integer}
    val = Vector{typeof(model.val)}(undef, Nparameter)
    index = F.(1:Nparameter)
    weight = zeros(Nparameter)
    return ModelParameterBuffer(val, index, weight)
end

function resize!(buffer::ModelParameterBuffer, Nparameter::Integer)
    resize!(buffer.val, Nparameter)
    resize!(buffer.index, Nparameter)
    resize!(buffer.weight, Nparameter)
    return nothing
end

function shuffle!(
    buffer::ModelParameterBuffer,
    model::AbstractVector{M},
    weights::AbstractVector{T}
    ) where {M<:AbstractModelWrapper, T<:Real}
    ## Shuffle Model parameter, log objective results and weights
    @inbounds for idx in Base.OneTo(length(buffer.val))
        #!NOTE: This one has pointer issues
        # buffer.val[idx] = model[buffer.index[idx]].val
        #!NOTE: This does NOT work with NamedTuples of NamedTuples, but much faster than deepcopy
        buffer.val[idx] = map(copy, model[buffer.index[idx]].val)
        buffer.weight[idx] = weights[buffer.index[idx]]
    end
    ## Return back to appropriate place
    #!NOTE: Cannot be performed in same loop as before
    @inbounds for idx in Base.OneTo(length(buffer.val))
        model[idx].val = buffer.val[idx]
        weights[idx] = buffer.weight[idx]
    end
    return nothing
end

#=
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
    model::AbstractVector{M},
    weights::AbstractVector{T}
    ) where {A<:AbstractAlgorithm, M<:AbstractModelWrapper, T<:Real}
    ## Shuffle Model parameter, log objective results and weights
    @inbounds for idx in Base.OneTo(length(buffer.val))
        buffer.val[idx] = model[buffer.index[idx]].val
        buffer.result[idx] = get_result(algorithm[buffer.index[idx]])
        buffer.weight[idx] = weights[buffer.index[idx]]
    end
    ## Return back to appropriate place
    #!NOTE: Cannot be performed in same loop as before
    @inbounds for idx in Base.OneTo(length(buffer.val))
        model[idx].val = buffer.val[idx]
        result!(algorithm[idx], buffer.result[idx])
        weights[idx] = buffer.weight[idx]
    end
    return nothing
end
=#

############################################################################################
# Export
export
    ParameterBuffer,
    ModelParameterBuffer,
    shuffle!
