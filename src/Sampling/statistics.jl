############################################################################################
"""
$(TYPEDEF)

Stores in diagnostics.

# Fields
$(TYPEDFIELDS)
"""
struct AcceptStatistic
    "Acceptance rate"
    rate::Float64
    "Step accepted or rejected"
    accepted::Bool
    function AcceptStatistic(rate::T, accepted::Bool) where {T<:AbstractFloat}
        ArgCheck.@argcheck 0.0 <= rate <= 1.0 "Acceptance rate is out of boundaries"
        return new(rate, accepted)
    end
end
function AcceptStatistic(_rng::Random.AbstractRNG, ℓacceptrate::F) where {F<:AbstractFloat}
    rate = exp(min(zero(F), ℓacceptrate))
    accepted = rand(_rng) < rate
    return AcceptStatistic(rate, accepted)
end

############################################################################################
# Export
export AcceptStatistic
