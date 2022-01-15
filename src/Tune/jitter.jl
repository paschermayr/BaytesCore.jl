############################################################################################
# Types and structs - Resampling Methods

############################################################################################
"""
$(TYPEDEF)

Container that determines if jittering has to be applied

# Fields
$(TYPEDFIELDS)
"""
struct JitterTune
    "Number of jitttering steps performed while jittering"
    Nsteps::Iterator
    "Jittering threshold for correlation of parameter."
    threshold::Float64
    "Minimum amount of jittering steps."
    min::Int64
    "Maximum amount of jittering steps."
    max::Int64
    function JitterTune(
        threshold::Float64,
        min::Integer=1,
        max::Integer=30
    )
        ArgCheck.@argcheck 0 < min < max
        ArgCheck.@argcheck 0.0 < threshold <= 1.0 "threshold needs to be positive"
        return new(Iterator(0), threshold, min, max)
    end
end

############################################################################################
function update!(tune::JitterTune)
    init!(tune.Nsteps, 0)
    return nothing
end

############################################################################################
"""
$(SIGNATURES)
Check if we can stop jittering step based on correlation ρ.

# Examples
```julia
```

"""
function jitter!(tune::JitterTune, ρ::T) where {T<:AbstractFloat}
    ## Add step to Nsteps
    update!(tune.Nsteps)
    ## Check if jittering has to be continued
    #!NOTE: Need to start with >= tune.max and < tune.min conditions, and then with ρ
    if tune.Nsteps.current >= tune.max
        return false
    elseif tune.Nsteps.current < tune.min
        return true
    #!NOTE: if not above or below boundary, check if correlation threshold is fullfiled
    # If correlation smaller than threshold, stop jittering
    elseif ρ < tune.threshold
        return false
    else
        return true
    end
end

############################################################################################
#export
export JitterTune, jitter!, update!
