#=
!NOTE:
1. This sections defines abstract types for structs/functions that need to be defined/overloaded so custom
algorithms(algorithms.jl), kernels inside an Baytes package (kernel.jl) can be used.
2. Super types defined before files are usually arguments in algorithm/kernel.
3. Functions shown in both, algorithms.jl and kernel.jl, need to be defined in either case.
=#
############################################################################################
# Define Abstract Super Types

############################################################################################
# Include files
include("algorithms.jl")
include("kernels.jl")
include("utility.jl")

############################################################################################
# Export
