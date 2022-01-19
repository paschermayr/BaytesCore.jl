############################################################################################
"""
$(TYPEDEF)

Tuning container for Tempering parameter.

# Fields
$(TYPEDFIELDS)
"""
struct TemperingTune{A<:UpdateBool, M<:TemperingMethod}
    "If true, temperature will be adapted."
    adaption::A
    "Method for adaption temperature"
    method::M
    function TemperingTune(adaption::A, method::M
    ) where {A<:UpdateBool, M<:TemperingMethod}
        return new{A,M}(adaption, method)
    end
end

function update!(
    tempering::TemperingTune,
    update::UpdateTrue,
    weights::AbstractVector,
    ESSTarget::T
    ) where {T<:AbstractFloat}
    update!(tempering.method, weights, ESSTarget)
    return nothing
end
function update!(
    tempering::TemperingTune,
    update::UpdateFalse,
    weights::AbstractVector,
    ESSTarget::T
    ) where {T<:AbstractFloat}
    return nothing
end
function update!(
    tempering::TemperingTune,
    weights::AbstractVector,
    ESSTarget::T
    ) where {T<:AbstractFloat}
    return update!(tempering, tempering.adaption, weights, ESSTarget)
end
############################################################################################
# Export
export
    TemperingTune,
    update!
