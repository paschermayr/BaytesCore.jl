############################################################################################

"""
$(SIGNATURES)
Numerically stable version for log(mean(exp(vec))).

# Examples
```julia
```

"""
function logmeanexp(arr::Vector{T}) where {T<:Real}
    return log(1 / size(arr, 1)) + LogExpFunctions.logsumexp(arr)
end

############################################################################################
"""
$(SIGNATURES)
Check if `x` is larger than `threshold`, guaranteeing same type for arguments.

# Examples
```julia
```

"""
function issmaller(x::T, threshold::T) where {T<:Real}
    #!TODO: function name ambigous if threshold name not explicitly mentioned
    #!NOTE: "<=" so Resampling at each iteration if threshold == 1.0
    return x <= threshold
end

############################################################################################
"""
$(SIGNATURES)
Return allocation friendly index of array argument.

# Examples
```julia
```

"""
function grab(data, index, sorted)
    return nothing
end

@inline function grab(
    data::AbstractVector{R}, index::I, sorted::S
) where {R,I<:Integer,S<:Union{ByRows,ByCols}}
    @inbounds return data[index]
end
@inline function grab(
    data::AbstractVector{R}, range::Union{Vector{I},UnitRange{I}}, sorted::S
) where {R,I<:Integer,S<:Union{ByRows,ByCols}}
    @inbounds return view(data, range)
end

@inline function grabcols(
    data::AbstractArray{R,2}, index::Union{I,Vector{I},UnitRange{I}}
) where {R,I<:Integer}
    return view(data, index, :)
end
@inline function grabrows(
    data::AbstractArray{R,2}, index::Union{I,Vector{I},UnitRange{I}}
) where {R,I<:Integer}
    return view(data, :, index)
end
function grab(
    data::AbstractArray{R,2}, idx::Union{I,Vector{I},UnitRange{I}}, sorted::ByRows
) where {R,I<:Integer}
    return grabcols(data, idx)
end
function grab(
    data::AbstractArray{R,2}, idx::Union{I,Vector{I},UnitRange{I}}, sorted::ByCols
) where {R,I<:Integer}
    return grabrows(data, idx)
end

grab(data, idx, config::ArrayConfig) = grab(data, idx, config.sorted)

############################################################################################
# Export
export logsumexp, #import from LogExpFunctions
    logaddexp, #import from LogExpFunctions
    logmeanexp, #import from LogExpFunctions
    issmaller,
    grab
