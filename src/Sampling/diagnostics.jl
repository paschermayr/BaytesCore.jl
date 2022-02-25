############################################################################################
"""
$(TYPEDEF)

Stores summary information for diagnostics output that is included in all Baytes kernels.

# Fields
$(TYPEDFIELDS)
"""
struct BaseDiagnostics{P}
    "Log objective target result."
    ℓobjective::Float64
    "Temperature for target result"
	temperature::Float64
    "Prediction of future data."
	prediction::P
    "Current iteration of kernel."
    iter::Int64
    function BaseDiagnostics(
        ℓobjective::S,
        temperature::T,
        prediction::P,
        iter::Integer
    ) where {S<:AbstractFloat, T<:AbstractFloat, P}
        return new{P}(ℓobjective, temperature, prediction, iter)
    end
end

############################################################################################
function get_prediction(diagnostics::BaseDiagnostics)
    return diagnostics.prediction
end

############################################################################################
"""
$(SIGNATURES)
Return `ℓobjective` scaled up to temperature == 1.

# Examples
```julia
```

"""
function untemper(diagnostics::BaseDiagnostics)
    return (1.0/diagnostics.temperature) * diagnostics.ℓobjective
end

############################################################################################
# Export
export BaseDiagnostics, untemper
