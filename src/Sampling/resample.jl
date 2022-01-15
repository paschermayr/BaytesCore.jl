############################################################################################
"""
$(TYPEDEF)
Super type for various particle resampling techniques.
"""
abstract type ResamplingMethod end

############################################################################################
"""
$(TYPEDEF)

Stores information about resampling steps.

# Fields
$(TYPEDFIELDS)
"""
struct ResampleTune{R<:ResamplingMethod}
    "Method for resampling."
    method::R
    "Stores if last iteration was resampled."
    update::Updater
    function ResampleTune(method::R, update::Updater) where {R<:ResamplingMethod}
        return new{R}(method, update)
    end
end
function update!(tune::ResampleTune)
    update!(tune.update)
    return nothing
end
function init!(tune::ResampleTune, bool::Bool)
    init!(tune.update, bool)
    return nothing
end

############################################################################################
"""
$(SIGNATURES)
Resample particles, dispatched on ResamplingMethod subtypes.

# Examples
```julia
```

"""
function resample! end

function resample!(
    _rng::Random.AbstractRNG,
    type::S,
    container::AbstractMatrix{<:Integer},
    iter::Integer,
    weights::Vector{<:Real},
    n::Integer=length(weights),
) where {S<:ResamplingMethod}
    return resample!(_rng, type, view(container, :, iter), iter, weights, n)
end

############################################################################################
"""
$(SIGNATURES)
More stable, faster version of rand(Categorical) if weights sum up to 1.

# Examples
```julia
```

"""
function randcat(_rng::Random.AbstractRNG, p::AbstractVector{<:Real})
    T = eltype(p)
    r = rand(_rng, T)
    cp = p[1]
    s = 1
    n = length(p)
    while cp <= r && s < n
        @inbounds cp += p[s += 1]
    end
    return s
end

############################################################################################
# Export
export
    ResamplingMethod,
    ResampleTune,
    resample!,
    randcat
