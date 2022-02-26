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
struct IterationTempering{A<:UpdateBool, T<:AbstractFloat} <: TemperingMethod
    "Checks if temperature will be updated after new iterations"
    adaption::A
    "Initial temperature for tempering."
    initial::ValueHolder{T}
    "Tuning parameter for temperature adjustment."
    parameter::TemperingParameter{T}
    function IterationTempering(adaption::A, val::ValueHolder{T}, parameter::TemperingParameter{T}
    ) where {A<:UpdateBool,T<:AbstractFloat}
        @argcheck 0.0 < val.current <= 1.0
        return new{A,T}(adaption, val, parameter)
    end
end

function IterationTempering(::Type{T}, adaption::B, val::F, idx::Integer
) where {T<:AbstractFloat, B<:UpdateBool, F<:AbstractFloat}
    # Assign temperature adaption
    parameter = TemperingParameter(T, val, idx)
    # Assign initial temperature
    val₀ = init(T, adaption, val, parameter)
    # Return tuning struct
    return IterationTempering(adaption, ValueHolder(val₀), parameter)
end

############################################################################################
function update!(tempering::IterationTempering, adaption::UpdateTrue, index::Integer)
    # Compute new temperature
    return update(tempering.parameter, index)
end
function update!(tempering::IterationTempering, adaption::UpdateFalse, index::Integer)
    return tempering.initial.current
end
function update!(tempering::IterationTempering, index::Integer)
    return update!(tempering, tempering.adaption, index)
end

############################################################################################
"""
$(SIGNATURES)
Return initial temperature of tuning container.

# Examples
```julia
```

"""
function initial(tempertune::IterationTempering)
    return tempertune.initial.current
end

############################################################################################
# Export
export
    IterationTempering,
    TemperingParameter,
    init,
    initial,
    update,
    update!
