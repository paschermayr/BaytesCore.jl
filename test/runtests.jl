############################################################################################
# Import External PackagesJK
using Test
using Random: Random, AbstractRNG, seed!
using Statistics

############################################################################################
# Import Baytes Packages
using BaytesCore

############################################################################################
# Include Files
include("TestHelper.jl")

############################################################################################
# Run Tests
@testset "All tests" begin
    include("test-Algorithm.jl")
    include("test-Buffer.jl")
    include("test-Core.jl")
    include("test-Sampling.jl")
    include("test-Tempering.jl")
end
