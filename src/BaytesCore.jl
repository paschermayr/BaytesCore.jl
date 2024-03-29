module BaytesCore

############################################################################################
#Import External packages
import Base: Base, split, resize!
import Random: Random, shuffle!
import LogExpFunctions: LogExpFunctions, logsumexp, logaddexp

using DocStringExtensions:
    DocStringExtensions, TYPEDEF, TYPEDFIELDS, FIELDS, SIGNATURES, FUNCTIONNAME
using ArgCheck: ArgCheck, @argcheck
using SimpleUnPack: @unpack, @pack!
using Random: Random, AbstractRNG, GLOBAL_RNG
using Statistics: Statistics, middle

############################################################################################
#Import
include("Algorithm/Algorithm.jl")
include("Core/Core.jl")
include("Tempering/Tempering.jl")
include("Buffer/Buffer.jl")
include("Sampling/Sampling.jl")

############################################################################################
#export

end
