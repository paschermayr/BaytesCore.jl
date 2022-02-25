############################################################################################
"Abstract type where more tempering methods have to be dispatched on."
abstract type TemperingMethod end

############################################################################################
# Include files
include("iteration.jl")
include("joint.jl")

############################################################################################
# Export
export
    TemperingMethod
