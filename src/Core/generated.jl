############################################################################################
"Mostly generated functions that allow to transform NamedTuples without much allocations. Not Exported."

############################################################################################
"""
$(SIGNATURES)
Subset `nt` with arguments `s`

# Examples
```julia
julia> subset( (a = 1., b = 2., c = 3.), (:a, :b) )
(a = 1., b = 2.)
```

"""
@inline subset(nt::NamedTuple, s::Tuple{Vararg{Symbol}}) = NamedTuple{s}(nt)
@inline subset(nt::NamedTuple, s::Symbol) = NamedTuple{(s,)}(nt)

############################################################################################
"""
$(SIGNATURES)
Convert Tuple tup to NamedTuple with all fields equal to val.

# Examples
```julia
```

"""
function Tuple_to_Namedtuple(tup::Tuple, val)
    return NamedTuple{tup}(map(x -> val, eachindex(tup)))
end

"""
$(SIGNATURES)
Convert Tuple tup to NamedTuple with fields equal to val.

# Examples
```julia
```

"""
function to_NamedTuple(tup::Tuple, val::AbstractVector)
    if length(tup) == 1
        #!NOTE Safe method even if Tuple is only a single symbol and val non-scalar
        return NamedTuple{tup}(map(x -> val, eachindex(tup)))
    else
        return NamedTuple{tup}(map(iter -> val[iter], eachindex(val)))
    end
end
############################################################################################
"""
$(SIGNATURES)
Subset NamedTuple obj with keys of s without allocations.

# Examples
```julia
```

"""
@generated function subset(obj::NamedTuple, s::NamedTuple)
    #!NOTE: https://discourse.julialang.org/t/generated-function-iterate-over-function-argument/66087/10
    fnames = fieldnames(s)
    fvals = map(fnames) do fname
        Expr(:call, :getproperty, :obj, QuoteNode(fname))
    end
    fvals = Expr(:tuple, fvals...)
    return :(NamedTuple{$fnames}($fvals))
end

############################################################################################
@generated function to_Tuple_generated(x)
    #!NOTE: see https://discourse.julialang.org/t/get-fieldnames-and-values-of-struct-as-namedtuple/8991/3
    tup = Expr(:tuple)
    for i in 1:fieldcount(x)
        push!(tup.args, :(getfield(x, $i)))
    end
    return :($tup)
end

############################################################################################
"""
$(SIGNATURES)
Subset NamedTuple x given symbols sym without additional allocations.

# Examples
```julia
```

"""
@generated function to_Tuple_generated(x, sym...)
    tup = Expr(:tuple)
    for v in sym
        push!(tup.args, :(getfield(x, getval($v))))
    end
    return :($tup)
end
getval(::Type{Val{T}}) where {T} = T

############################################################################################
#=
"""
$(SIGNATURES)
Convert struct x to NamedTuple without additional allocations.

# Examples
```julia
```

"""
=#
@generated function to_NamedTuple_generated(x)
    nt = Expr(:quote, generate_tuple(x))
    tup = Expr(:tuple)
    for i in 1:fieldcount(x)
        push!(tup.args, :(getfield(x, $i)))
    end
    return :($nt($tup))
end
function generate_tuple(container)
    return NamedTuple{
        (fieldnames(container)...,),
        Tuple{(fieldtype(container, i) for i in 1:fieldcount(container))...},
    }
end

############################################################################################
"""
$(SIGNATURES)
Generate union of fields from 2 NamedTuples x and y.

# Examples
```julia
```

"""
@generated function keyunion(x::NamedTuple{Kx,Tx}, y::NamedTuple{Ky,Ty}) where {Kx,Tx,Ky,Ty}
    return union(Kx, Ky)
end

############################################################################################
# Export
