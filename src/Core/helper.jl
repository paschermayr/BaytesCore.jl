############################################################################################
"""
$(TYPEDEF)

Abstract super type if update has to be applied for given function.

# Fields
$(TYPEDFIELDS)
"""
abstract type UpdateBool end
struct UpdateTrue <: UpdateBool end
struct UpdateFalse <: UpdateBool end

############################################################################################
"""
$(TYPEDEF)

Mutable struct to store update information that can be stored and updated in immutable structs. Contains boolean if updated is needed.
Note that a UpdateBool field cannot be stored and updated as a concrete type here.

# Fields
$(TYPEDFIELDS)
"""
mutable struct Updater
    "Boolean of whether update has to be applied"
    current::Bool
    function Updater(start::Bool)
        return new(start)
    end
end
function update!(updater::Updater)
    updater.current = updater.current ? false : true
    return nothing
end
function init!(updater::Updater, update::Bool)
    updater.current = update
    return nothing
end

############################################################################################
"""
$(TYPEDEF)

Mutable struct to hold a single scalar value that can be stored and updated in immutable structs.

# Fields
$(TYPEDFIELDS)
"""
mutable struct ValueHolder{T<:Real}
    "Scalar value"
    current::T
    function ValueHolder(val::T) where {T<:Real}
        return new{T}(val)
    end
end
function update!(value::ValueHolder{T}, val::T) where {T<:Real}
    value.current = val
    return nothing
end
function init!(value::ValueHolder{T}, val::T) where {T<:Real}
    value.current = val
    return nothing
end

############################################################################################
"""
$(TYPEDEF)

Mutable struct that can be stored and updated in immutable structs. Contains current iteration value.

# Fields
$(TYPEDFIELDS)
"""
mutable struct Iterator
    "Current iteration number."
    current::Int64
    function Iterator(start::Int64)
        return new(start)
    end
end
function update!(iterator::Iterator)
    iterator.current += 1
    return nothing
end
function init!(iterator::Iterator, val::I) where {I<:Integer}
    iterator.current = val
    return nothing
end

############################################################################################
"""
$(TYPEDEF)

Mutable iterator struct that can be stored and updated in immutable structs. Contains cumulative and current value of input.

# Fields
$(TYPEDFIELDS)
"""
mutable struct Accumulator
    "Cumulative value of all inputs."
    cumulative::Float64
    "Current input value."
    current::Float64
    function Accumulator()
        return new(0.0, 0.0)
    end
end
function update!(accumulator::Accumulator, val::T) where {T<:AbstractFloat}
    accumulator.current = val
    accumulator.cumulative += accumulator.current
    return nothing
end
function init!(accumulator::Accumulator)
    accumulator.current = 0.0
    accumulator.cumulative = 0.0
    return nothing
end

############################################################################################
# Export
export UpdateBool, UpdateTrue, UpdateFalse, Updater, Iterator, Accumulator, ValueHolder
