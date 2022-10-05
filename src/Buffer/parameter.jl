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
struct ModelParameterBuffer{M<:NamedTuple, S<:Real, T<:AbstractFloat, I<:Integer}
    "Model parameter in constrained space as NamedTuple."
    val::Vector{M}
    "Model parameter in unconstrained space as Vector."
    valᵤ::Vector{Vector{S}}
    "Stores Weight of val used for resampling `val`."
    weight::Vector{T}
    "Indices for model parameter in the chain."
    index::Vector{I}
    function ModelParameterBuffer(
        val::Vector{M},
        valᵤ::Vector{Vector{S}},
        weight::Vector{T},
        index::Vector{I},
        ) where {M<:NamedTuple, S<:Real, T<:AbstractFloat, I<:Integer}
        return new{M, S, T, I}(val, valᵤ, weight, index)
    end
end

function ModelParameterBuffer(
    model::M,
    Nchains::Integer,
    Nparameter::Integer,
    ValType::Type{S},
    IndexType::Type{I}
    ) where {M<:AbstractModelWrapper, S<:Real ,I<:Integer}
    val = Vector{typeof(model.val)}(undef, Nchains)
    valᵤ = map(iter -> Vector{ValType}(undef, Nparameter), Base.OneTo(Nchains))
    weight = zeros(Nchains)
    index = IndexType.(1:Nchains)
    return ModelParameterBuffer(val, valᵤ, weight, index)
end

function resize!(buffer::ModelParameterBuffer, Nchains::Integer)
    resize!(buffer.val, Nchains)
    resize!(buffer.valᵤ, Nchains)
    resize!(buffer.weight, Nchains)
    resize!(buffer.index, Nchains)
    return nothing
end

"""
$(SIGNATURES)
Copy value, if no NamedTuple, use faster copy version instead of NamedTuple.
# Examples
```julia
```

"""
function _copy(val)
    return copy(val)
end
function _copy(val::NamedTuple)
    return deepcopy(val)
end

function shuffle!(
    buffer::ModelParameterBuffer,
    model::AbstractVector{M},
    algorithm::AbstractVector{A},
    weights::AbstractVector{T}
    ) where {A<:AbstractAlgorithm, M<:AbstractModelWrapper, T<:Real}
    ## Shuffle Model parameter, log objective results and weights
    @inbounds for idx in Base.OneTo(length(buffer.val))
        #!NOTE: This one has pointer issues:
        # buffer.val[idx] = model[buffer.index[idx]].val
        #!NOTE: copy does NOT work with NamedTuples of NamedTuples, but much faster than deepcopy
        buffer.val[idx] = map(_copy, model[buffer.index[idx]].val)
        buffer.weight[idx] = weights[buffer.index[idx]]
        #!NOTE Initial parameter stored to compute correlation against jittered parameter in unconstrained space
        result = BaytesCore.get_result(algorithm[buffer.index[idx]])
        for iter in eachindex(result.θᵤ)
            buffer.valᵤ[idx][iter] = result.θᵤ[iter]
        end
    end
    ## Return back to appropriate place
    #!NOTE: Cannot be performed in same loop as before
    @inbounds for idx in Base.OneTo(length(buffer.val))
        model[idx].val = buffer.val[idx]
        weights[idx] = buffer.weight[idx]
        #!NOTE: There is not need to swap out results from algorithm vector, as UpdateTrue() will be used for first jitter step
        #!NOTE: buffer.valᵤ only used to compute correlation of jittered vs initial parameter
    end
    return nothing
end

############################################################################################
# Export
export
    ParameterBuffer,
    ModelParameterBuffer,
    shuffle!
