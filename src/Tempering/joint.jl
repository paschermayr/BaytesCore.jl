############################################################################################
"""
$(SIGNATURES)
Compute ESS as a function of proposed temperature `λ` against current temperature `λₜ₋₁`.
Note that weights are in the original (non-log) space, and should have temperature == 1.
# Examples
```julia
```

"""
function weightedESS(weights::AbstractVector{T}, λ::T, λₜ₋₁::T) where {T<:AbstractFloat}
    ArgCheck.@argcheck 0 < λₜ₋₁ <= λ <= 1.0
    num = sum(weights[iter]^(λ - λₜ₋₁) for iter in eachindex(weights))^2
    denom = sum(weights[iter]^(λ - λₜ₋₁)^2 for iter in eachindex(weights))
    return num/denom
end

############################################################################################
"""
$(SIGNATURES)
Closure to compute new temperature `λ` as a function of weights `weights` and current temperature `λₜ₋₁`.
`ESSTarget` is the benchmark to optimize against.

# Examples
```julia
```

"""
function get_ESSDifference(weights::AbstractVector{T}, λₜ₋₁::T, ESSTarget::T) where {T<:AbstractFloat}
    ArgCheck.@argcheck 0 < ESSTarget
    function ESSDifference(λ)
        return ESSTarget - weightedESS(weights, λ, λₜ₋₁)
    end
end

############################################################################################
"""
$(SIGNATURES)
Temperature adaption that takes into account updating schedule, see Chopin, Papaspiliopoulos (2020).
# Examples
```julia
```

"""
function update(weights::AbstractVector{T}, λₜ₋₁::T, ESSTarget::T) where {T<:AbstractFloat}
    # Assing ESS closure
    ESSDifference = get_ESSDifference(weights, λₜ₋₁, ESSTarget)
    # Check if ESS > ESSTarget; !NOTE: Compute ESS, not ESSDifference!
    if weightedESS(weights, T(1.0), λₜ₋₁) >= ESSTarget
        return T(1.0)
    end
    # Else tune for new stepsize
    λ = bisect(ESSDifference, λₜ₋₁, T(1.0))
    return λ
end

"Inverse CDF of Univariate Normal Mixture Model, where prob can be vectorized as a bivariate array of observations."
function bisect(f, min, max, atol = 10e-4, increasing = sign(f(max)), iter_max = 1000)
    c = Statistics.middle(min, max)
    z = f(c) * increasing
    iter = 0
    if z > 0 #
        maxi = c
        mini = typeof(maxi)(min)
    else
        mini = c
        maxi = typeof(mini)(max)
    end
    @inbounds while abs(mini - maxi) > atol && iter < iter_max
        iter += 1
        c = Statistics.middle(mini,maxi)
        if f(c) * increasing > 0 #
            maxi = c
        else
            mini = c
        end
    end
    #return output
    if iter < iter_max
        return Statistics.middle(mini,maxi)
    else
        return -Inf
    end
end

############################################################################################
"""
$(TYPEDEF)

Tuning container for joint uptdates of temperature.

# Fields
$(TYPEDFIELDS)
"""
struct JointTempering{A<:UpdateBool, T<:AbstractFloat} <: TemperingMethod
    "Checks if temperature will be updated after new iterations"
    adaption::A
    "current temperature."
    val::ValueHolder{T}
    "Target Effective Sample Size."
    ESSTarget::ValueHolder{T}
    "Buffer for weights used to adapt temperature"
    weights::Vector{T}
    function JointTempering(adaption::A, val::ValueHolder{T}, ESSTarget::ValueHolder{T}, weights::Vector{T}
    ) where {A<:UpdateBool,T<:AbstractFloat}
        @argcheck 0.0 < val.current <= 1.0
        @argcheck 0.0 < ESSTarget.current <= length(weights)
        return new{A,T}(adaption, val, ESSTarget, weights)
    end
end

function JointTempering(::Type{T}, adaption::B, val::F, ESSTarget::S, chains::Integer
) where {T<:AbstractFloat, B<:UpdateBool, F<:AbstractFloat, S<:AbstractFloat}
    # Return tuning struct
    return JointTempering(adaption, ValueHolder(T(val)), ValueHolder(T(ESSTarget)), zeros(T, chains))
end

############################################################################################
function update!(tempering::JointTempering, adaption::UpdateTrue, ℓweights::AbstractVector)
    # Update weights
    for iter in eachindex(tempering.weights)
        tempering.weights[iter] = ℓweights[iter]
    end
    #Normalize numerically stable
    tempering.weights .-= logsumexp(tempering.weights)
    tempering.weights .= exp.(tempering.weights)
    # Compute new temperature
    tempering.val.current = update(tempering.weights, tempering.val.current, tempering.ESSTarget.current)
    return tempering.val.current
end

############################################################################################
function update!(tempering::JointTempering, adaption::UpdateFalse, weights::AbstractVector)
    return tempering.val.current
end
function update!(tempering::JointTempering, weights::AbstractVector)
    return update!(tempering, tempering.adaption, weights)
end

############################################################################################
"""
$(SIGNATURES)
Return initial temperature of tuning container.

# Examples
```julia
```

"""
function initial(tempertune::JointTempering)
    return tempertune.val.current
end

############################################################################################
# Export

export
    JointTempering,
    initial,
    update,
    update!
