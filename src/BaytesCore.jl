" ModelWrappers - Contains useful code to perform inference on algorithms."
module BaytesCore

############################################################################################
#Import External packages
import LogExpFunctions: LogExpFunctions, logsumexp, logaddexp

using DocStringExtensions:
    DocStringExtensions, TYPEDEF, TYPEDFIELDS, FIELDS, SIGNATURES, FUNCTIONNAME
using ArgCheck: ArgCheck, @argcheck
using Random: Random, AbstractRNG, GLOBAL_RNG

############################################################################################
#Import
include("Dispatch/Dispatch.jl")
include("Core/Core.jl")

function checkifmysuperlongfunctiongetsappropriatelytaggedwithbluestyle(myfirstargument, x, mythirdargument)
                    x     = 3
                return nothing
end


############################################################################################
#export

end
