############################################################################################
"Abstract type where more tempering methods have to be dispatched on."
abstract type TemperingMethod end

############################################################################################
# Include files
#include("default.jl") #!NOTE: Initial plan to make tempertune easier to construct
#include("tune.jl") #!NOTE: Initial plan to make tempertune easier to construct
include("iteration.jl")
include("joint.jl")

############################################################################################
# Export
export
    TemperingMethod
