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

#= DISCLAIMER & CREDIT TO:
    StatsFuns.jl/DynamicHMC.jl for cornercase of infinite x/y
=#
function logaddexp(x, y)
    isfinite(x) && isfinite(y) || return max(x, y)
    return if x > y
        x + LogExpFunctions.log1p(exp(y - x))
    else
        y + LogExpFunctions.log1p(exp(x - y))
    end
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
    logmeanexp,
    grab
