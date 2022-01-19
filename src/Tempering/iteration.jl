############################################################################################
"""
$(TYPEDEF)

Holds information about updating tempering parameter, parameter for basic logistic function.

# Fields
$(TYPEDFIELDS)
"""
struct TemperingParameter{T<:AbstractFloat}
    L::T
    k::T
    x₀::T
    function TemperingParameter(L::T, k::T, x₀::T) where {T<:AbstractFloat}
        ArgCheck.@argcheck 0 < L
        ArgCheck.@argcheck 0 < k
        return new{T}(L, k, x₀)
    end
end
function TemperingParameter(::Type{T}, growthrate::F, iterations::Integer; normalizer::Float64 = 100.0
) where {F<:AbstractFloat, T<:AbstractFloat}
    return TemperingParameter(T(1.0), T(growthrate*normalizer/iterations), T(growthrate*iterations/normalizer))
end

############################################################################################
"""
$(SIGNATURES)
Initialize temperature.

# Examples
```julia
```

"""
function init(::Type{T}, adaption::UpdateFalse, val::F, parameter::TemperingParameter
) where {T<:AbstractFloat, F<:AbstractFloat}
    return T(val)
end
function init(::Type{T}, adaption::UpdateTrue, val::F, parameter::TemperingParameter
) where {T<:AbstractFloat, F<:AbstractFloat}
    return update(parameter, 1)
end

############################################################################################
"""
$(SIGNATURES)
Calculate new temperature based on current iteration.

# Examples
```julia
```

"""
function update(param::TemperingParameter{T}, index::Integer) where {T<:AbstractFloat}
    @unpack L, k, x₀ = param
    return L / (1 + exp(-k*(T(index) - x₀)))
end

############################################################################################
"""
$(SIGNATURES)
Helper function to determine temperature shape given param variables.

# Examples
```julia
```

"""
function checktemperature(param::TemperingParameter, iterations::Integer)
    return map(iter -> udpate(param, iter), Base.OneTo(iterations))
end

############################################################################################
"""
$(TYPEDEF)

Tuning container for iteration uptdates of temperature.

# Fields
$(TYPEDFIELDS)
"""
struct IterationTempering{T<:AbstractFloat} <: TemperingMethod
    "current temperature for each chain."
    val::ValueHolder{T}
    "Tuning parameter for temperature adjustment."
    parameter::TemperingParameter{T}
    function IterationTempering(val::ValueHolder{T}, parameter::TemperingParameter{T}
    ) where {T<:AbstractFloat}
        @argcheck 0.0 < val.current <= 1.0
        return new{T}(val, parameter)
    end
end

function IterationTempering(::Type{T}, adaption::B, val::F, idx::Integer
) where {T<:AbstractFloat, B<:UpdateBool, F<:AbstractFloat}
    # Assign temperature adaption
    parameter = TemperingParameter(T, val, idx)
    # Assign initial temperature
    val₀ = init(T, adaption, val, parameter)
    # Return tuning struct
    return IterationTempering(ValueHolder(val₀), parameter)
end

############################################################################################
function update!(tempering::IterationTempering, adaption::UpdateTrue, index::Integer)
    # Compute new temperature
    tempering.val.current = update(tempering.parameter, index)
    return tempering.val.current
end
function update!(tempering::IterationTempering, adaption::UpdateFalse, index::Integer)
    return tempering.val.current
end

############################################################################################
# Export
export
    IterationTempering,
    TemperingParameter,
    init,
    update,
    update!