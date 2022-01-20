############################################################################################
"Abstract type where more tempering methods have to be dispatched on."
abstract type TemperingMethod end

############################################################################################
# Include files
include("default.jl")
include("iteration.jl")
include("joint.jl")
include("tune.jl")

############################################################################################
# Export
export
    TemperingMethod
