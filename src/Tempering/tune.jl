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

############################################################################################
# Export
export
    TemperingTune
