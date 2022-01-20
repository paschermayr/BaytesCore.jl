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

#!NOTE: Cant use DocumenterTools for Base functions
"Split `default.val` temperatures into sepatre `TemperDefault` structs with scalar temperature."
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
# Export
export TemperDefault, split
