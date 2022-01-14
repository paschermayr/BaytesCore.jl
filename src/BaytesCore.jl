module BaytesCore

############################################################################################
#Import External packages
import Base: Base, split
import Random: Random, shuffle!
import LogExpFunctions: LogExpFunctions, logsumexp, logaddexp

using DocStringExtensions:
    DocStringExtensions, TYPEDEF, TYPEDFIELDS, FIELDS, SIGNATURES, FUNCTIONNAME
using ArgCheck: ArgCheck, @argcheck
using UnPack: @unpack, @pack!
using Random: Random, AbstractRNG, GLOBAL_RNG

############################################################################################
#Import
include("Dispatch/Dispatch.jl")
include("Core/Core.jl")
include("Defaults/Defaults.jl")
include("Sampling/Sampling.jl")

############################################################################################
#export

end
