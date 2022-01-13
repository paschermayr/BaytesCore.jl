############################################################################################
"""
$(TYPEDEF)

Default arguments for tempering target function.

# Fields
$(TYPEDFIELDS)
"""
struct TemperDefault{A<:UpdateBool, T<:Union{R, AbstractVector{R}} where {R<:AbstractFloat}}
    "Checks if temperature will be updated after new iterations"
    adaption::A
    "Initial value for temperature if adaption is used.
    Otherwise used to change shape of temperature until it reaches 1.0.
    The smaller, the more linear the trajectory. The higher, the sooner 1.0 will be reached."
    val::T
    function TemperDefault(adaption::A, val::T
    ) where {A<:UpdateBool, T<:Union{R, AbstractVector{R}} where {R<:AbstractFloat}}
    return new{A,T}(adaption, val)
    end
end
function TemperDefault()
    return TemperDefault(UpdateFalse(), 1.0)
end

"""
$(TYPEDEF)

split `default.val` temperatures into sepatre `TemperDefault` structs with scalar temperature.

# Fields
$(TYPEDFIELDS)
"""
function split(default::TemperDefault{B, F}
) where {B<:UpdateBool, F<:AbstractVector}
    return map(val -> TemperDefault(default.adaption, val), default.val)
end
function split(default::TemperDefault{B, F}, chains::Integer
) where {B<:UpdateBool, F<:AbstractFloat}
    return map(iter -> TemperDefault(default.adaption, default.val), Base.OneTo(chains))
end
function split(default::TemperDefault{B, F}, chains::Integer
) where {B<:UpdateBool, F<:AbstractVector}
    ArgCheck.@argcheck length(default.val) == chains
    return split(default)
end

############################################################################################
"""
$(TYPEDEF)

Holds information about updating tempering parameter, parameter for basic logistic function

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
$(SIGNATURES)
Initialize temperature.

# Examples
```julia
```

"""
function init(::Type{T}, adaption::UpdateFalse, default::TemperDefault{UpdateFalse, F}, parameter::TemperingParameter
) where {T<:AbstractFloat, F<:AbstractFloat}
    return T(default.val)
end
function init(::Type{T}, adaption::UpdateTrue, default::TemperDefault{UpdateTrue, F}, parameter::TemperingParameter
) where {T<:AbstractFloat, F<:AbstractFloat}
    return update(parameter, 1)
end
function init(::Type{T}, default::TemperDefault, parameter::TemperingParameter) where {T<:AbstractFloat}
    return init(T, default.adaption, default, parameter)
end

############################################################################################
"""
$(TYPEDEF)

Summary struct for Tempering parameter.

# Fields
$(TYPEDFIELDS)
"""
struct TemperingTune{A<:UpdateBool, T<:AbstractFloat}
    "If true, temperature will be adapted."
    adaption::A
    "current temperature."
    val::ValueHolder{T}
    "Tuning parameter for temperature adjustment."
    parameter::TemperingParameter{T}
    function TemperingTune(adaption::A, val::ValueHolder{T}, parameter::TemperingParameter{T}
    ) where {A<:UpdateBool, T<:AbstractFloat}
        @argcheck 0.0 < val.current <= 1.0
        return new{A,T}(adaption, val, parameter)
    end
end
function TemperingTune(::Type{T}, default::TemperDefault{B, F}, idx::Integer
) where {T<:AbstractFloat, B<:UpdateBool, F<:AbstractFloat}
    # Assign temperature adaption
    parameter = TemperingParameter(T, default.val, idx)
    # Assign initial temperature
    val = init(T, default, parameter)
    # Return tuning struct
    return TemperingTune(default.adaption, ValueHolder(val), parameter)
end

############################################################################################
# Export
export TemperDefault, TemperingTune, TemperingParameter, update, checktemperature, init, split
