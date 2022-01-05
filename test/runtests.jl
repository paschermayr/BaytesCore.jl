############################################################################################
# Import External PackagesJK
using Test
using Random: Random, AbstractRNG, seed!

############################################################################################
# Import Baytes Packages
using BaytesCore

############################################################################################
# Include Files
include("TestHelper.jl")

############################################################################################
# Run Tests
@testset "All tests" begin
    include("test-data.jl")
end
