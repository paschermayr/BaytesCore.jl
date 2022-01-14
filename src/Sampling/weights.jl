#=
Some notes to myself because I always forget it:
-> Estimate normalizing marginal likelihood term in P(s_1:t | e_1:t) via mean(w_1:t)
-> calculate w_1:t iteratively via w_t-k:t
-> in SIS we calculate normalizing W_t ∝ W_t-1 * w_t-k:t
-> in PF we always calculate normalizing W_t ∝ w_t-k:t, because W_t-1 is constant from resampling step.
-> in adaptive Res. PF, we still need normalizing W_t ∝ W_t-1 * w_t-k:t. In case resampled, W_t is constant, if not need SIS calculation.
-> Sometimes people define unnormalized w_t via w_t-1 * g(..) -> but this refers to w_1:t for each step! Not what we need in PF, as we calculate normalizing term iteratively.
=#

############################################################################################
"""
$(TYPEDEF)
Super type for parameter weighting techniques.
"""
abstract type ParameterWeighting end

"""
$(SIGNATURES)
Weight function that is dispatched on BaytesCore.ParameterWeighting types.

# Examples
```julia
```

"""
function weight!() end

############################################################################################
"""
$(TYPEDEF)

Container for weights and normalized particles weights at current time step t.

# Fields
$(TYPEDFIELDS)
"""
struct ParameterWeights
    "Used for log likelihood calculation."
    ℓweights::Vector{Float64}
    "exp(ℓweightsₙ) used for resampling particles and sampling trajectories ~ kept in log space for numerical stability."
    ℓweightsₙ::Vector{Float64}
    "A buffer vector with same size as ℓweights and ℓweightsₙ."
    buffer::Vector{Float64}
    function ParameterWeights(Nparameter::I) where {I<:Integer}
        ArgCheck.@argcheck Nparameter > 0 "Number of particles need to be positive."
        return new(
            fill(log(1.0 / Nparameter), Nparameter),
            fill(log(1.0 / Nparameter), Nparameter),
            fill(1.0 / Nparameter, Nparameter),
        )
    end
end

############################################################################################
#!NOTE: Cannot document functor
# Returns log weights and normalized log weights at time > 1.
function (weights::ParameterWeights)(ℓevidenceₜ::AbstractVector{T}) where {T<:Real}
    weights.ℓweights .= ℓevidenceₜ #Incremental weight
    normalize!(weights)
    return nothing
end

############################################################################################
"""
$(SIGNATURES)
Set weights back to equal.

# Examples
```julia
```

"""
function update!(weights::ParameterWeights)
    weights.ℓweights .= weights.ℓweightsₙ .= log(1.0 / length(weights.buffer))
    return nothing
end

############################################################################################
"""
$(SIGNATURES)
Inplace-Normalize parameter weights, accounting for ℓweightsₙ at previous iteration.

# Examples
```julia
```

"""
function normalize!(weights::ParameterWeights)
    # Wₜ ∝ Wₜ₋₁×wₜ #!NOTE: Relevant if no resampling step performed
    weights.ℓweightsₙ .= (weights.ℓweightsₙ .+ weights.ℓweights)
    weights.ℓweightsₙ .-= logsumexp(weights.ℓweightsₙ)
    return nothing
end

############################################################################################
"""
$(SIGNATURES)
Compute effectice sample size of particle filter via normalized log weights.

# Examples
```julia
```

"""
function computeESS(weightsₙ::Vector{T}) where {T<:AbstractFloat}
    return 1.0 / sum(abs2, weightsₙ)
end
function computeESS(weights::ParameterWeights)
    weights.buffer .= exp.(weights.ℓweightsₙ)
    return 1.0 / sum(abs2, weights.buffer)
end

############################################################################################
"""
$(SIGNATURES)
Draw proposal trajectory index.

# Examples
```julia
```

"""
function draw!(_rng::Random.AbstractRNG, weights::ParameterWeights)
    ## Draw new path
    weights.buffer .= exp.(weights.ℓweightsₙ)
    path = randcat(_rng, weights.buffer)
    ## Return trajectory
    return path
end

############################################################################################
# Export
export
    ParameterWeighting,
    weight!,
    ParameterWeights,
    draw!,
    normalize!,
    computeESS
