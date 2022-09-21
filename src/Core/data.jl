############################################################################################
"Abstract super type for sorting data in different dimensions."
abstract type DataSorting end
"Data is sorted by rows."
struct ByRows <: DataSorting end
"Data is sorted by columns."
struct ByCols <: DataSorting end

"""
$(TYPEDEF)
Array configuration struct.

Checks if data is propagated row or column wise.

# Fields
$(TYPEDFIELDS)
"""
struct ArrayConfig{K,T<:DataSorting}
    "Dimension of data."
    size::NTuple{K,Int64}
    "Boolean if data is sorted by row"
    sorted::T
    function ArrayConfig(arraysize::NTuple{K,Int64}) where {K}
        ArgCheck.@argcheck length(arraysize) < 3 "Array dimension only allowed to be in 1 or 2 dimensions."
        ## Check if data is per row or column
        if length(arraysize) > 1 && arraysize[1] < arraysize[2]
            sorted = ByCols()
        else
            sorted = ByRows()
        end
        return new{K,typeof(sorted)}(arraysize, sorted)
    end
end
ArrayConfig(array::AbstractArray{T}) where {T} = ArrayConfig(size(array))

############################################################################################
"Abstract super type to define valid data structures."
abstract type DataStructure end

"""
$(TYPEDEF)
Determines whether data can be subsampled for inference.

# Fields
$(TYPEDFIELDS)
"""
struct SubSampled <: DataStructure
    "Buffer index for subsampled indices."
    buffer::Vector{Int64}
end
SubSampled(n::Integer) = SubSampled(repeat(1:n, 1))

"""
$(TYPEDEF)
Determines if data size for sampler is increasing over time.

# Fields
$(TYPEDFIELDS)
"""
struct Expanding <: DataStructure
    "maximal visible index"
    index::Iterator
end
Expanding(t::Integer) = Expanding(Iterator(t))

"""
$(TYPEDEF)
Determines if data size for sampler is rolled forward over time.

# Fields
$(TYPEDFIELDS)
"""
struct Rolling <: DataStructure
    "Rolling window."
    length::Int64
    "maximal visible index"
    index::Iterator
end
Rolling(t::Integer) = Rolling(t, Iterator(t))

"""
$(TYPEDEF)
Determines whether only full data can be used.

# Fields
$(TYPEDFIELDS)
"""
struct Batch <: DataStructure end

############################################################################################
"""
$(TYPEDEF)
Data tuning struct.

Contains information about data structure.

# Fields
$(TYPEDFIELDS)
"""
struct DataTune{D<:DataStructure,C<:Union{Nothing, ArrayConfig},M}
    "Subtype of DataStructure"
    structure::D
    "Data dimension configuration."
    config::C
    "Treatment of missing data."
    miss::M
    function DataTune(
        structure::D, config::C, miss::M
    ) where {D<:DataStructure,C<:Union{Nothing, ArrayConfig}, M}
        return new{D,C,M}(structure, config, miss)
    end
end

function DataTune(data, structure::Batch, miss=nothing)
    return DataTune(structure, nothing, miss)
end
function DataTune(data::AbstractArray{T}, structure::D, miss=nothing
) where {T, D<:Union{SubSampled, Expanding, Rolling}}
    return DataTune(structure, ArrayConfig(data), miss)
end

function DataTune(structure::Batch)
    return DataTune(Batch(), nothing, nothing)
end


############################################################################################
"""
$(SIGNATURES)
Update datetune struct based on datastructure.

# Examples
```julia
```

"""
function update!(_rng::Random.AbstractRNG, tune::DataTune, structure::Batch)
    return nothing
end
function update!(_rng::Random.AbstractRNG, tune::DataTune, structure::Expanding)
    update!(tune.structure.index)
    return nothing
end
function update!(_rng::Random.AbstractRNG, tune::DataTune, structure::Rolling)
    update!(tune.structure.index)
    return nothing
end

function update!(_rng::Random.AbstractRNG, tune::DataTune, structure::SubSampled)
    idx = 1:maximum(tune.config.size)
    @inbounds for iter in eachindex(tune.structure.buffer)
        tune.structure.buffer[iter] = rand(_rng, idx)
    end
    return nothing
end
update!(_rng::Random.AbstractRNG, tune::DataTune) = update!(_rng, tune, tune.structure)

############################################################################################
"""
$(SIGNATURES)
Adjust data with current datatune configuration.

# Examples
```julia
```

"""
function adjust(tune::DataTune{<:Batch}, data)
    return data
end
function adjust(tune::DataTune{<:SubSampled}, data)
    return grab(data, tune.structure.buffer, tune.config)
end

function adjust(tune::DataTune{<:Expanding}, data)
    return grab(data, 1:(tune.structure.index.current), tune.config)
end
function adjust(tune::DataTune{<:Rolling}, data)
    return grab(
        data,
        (tune.structure.index.current - tune.structure.length + 1):(tune.structure.index.current),
        tune.config,
    )
end

############################################################################################
"""
$(SIGNATURES)
Adjust data with datatune configuration from previous iteration.

# Examples
```julia
```

"""
function adjust_previous(tune::DataTune{<:Batch}, data)
    return adjust(tune, data)
end
function adjust_previous(tune::DataTune{<:SubSampled}, data)
    return adjust(tune, data)
end

function adjust_previous(tune::DataTune{<:Expanding}, data)
    return grab(data, 1:(tune.structure.index.current - 1), tune.config)
end
function adjust_previous(tune::DataTune{<:Rolling}, data)
    dat_start = max(1, (tune.structure.index.current - tune.structure.length))
    return grab(
        data,
        dat_start:(tune.structure.index.current - 1),
        tune.config,
    )
end

############################################################################################
#export
export ArrayConfig, DataTune, update!, DataStructure, SubSampled, Expanding, Rolling, Batch
