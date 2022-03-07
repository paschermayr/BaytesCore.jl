############################################################################################
buffer_nparameter = 100
buffer_newparam = 10
buffer_ValType = [Float32, Float64]
buffer_IType = [Int32, Int64]

############################################################################################
# ParameterBuffer
@testset "Buffer - ParameterBuffer: " begin
    for vtype in buffer_ValType
        for itype in buffer_IType
            param1 = ParameterBuffer(vtype.(1:buffer_nparameter), buffer_nparameter, itype)
            param2 = ParameterBuffer(vtype(1), buffer_nparameter, itype)
            # Check types and size of buffer
            @test eltype(param1.val) == eltype(param2.val) == vtype
            @test eltype(param1.index) == eltype(param2.index) == itype
            @test length(param1.val) == length(param1.index) ==
                length(param2.val) == length(param2.index) == buffer_nparameter
            # Resize and check again
            buffer_nparameter_new = buffer_nparameter + buffer_newparam
            _param1 = deepcopy(param1)
            _param2 = deepcopy(param2)
            resize!(_param1, buffer_nparameter_new)
            resize!(_param2, buffer_nparameter_new)
            @test length(_param1.val) == length(_param1.index) ==
                length(_param2.val) == length(_param2.index) == buffer_nparameter_new
            @test length(param1.val) + buffer_newparam == length(_param1.val)
            # Shuffle and check if correct
            θnew = collect(100.0:-1:1.0)
            __param1 = deepcopy(param1)
            shuffle!(__param1, θnew)
            @test __param1.val[begin] == θnew[begin]
        end
    end
end

############################################################################################
# ModelParameterBuffer
mutable struct Mod{T} <: AbstractModelWrapper
    val::T
end
buffer_vals = [
    (a = 1., b = 2),
    (c = zeros(10), d = zeros(2,3))
]
struct Res <: AbstractResult end
mutable struct Alg{R} <: AbstractAlgorithm
    res::R
end
import BaytesCore: get_result, result!
function get_result(alg::Alg)
    return alg.res
end
function result!(alg::Alg, result)
    alg.res = result
end

@testset "Buffer - ModelParameterBuffer: " begin
    for val in buffer_vals
        for itype in buffer_IType
            param = ModelParameterBuffer(Mod(val), Res(), buffer_nparameter, itype)
            # Check types and size of buffer
            @test eltype(param.val) == typeof(val)
            @test length(param.val) == length(param.index) ==
                length(param.result) == length(param.weight ) == buffer_nparameter
            # Resize and check again
            buffer_nparameter_new = buffer_nparameter + buffer_newparam
            _param = deepcopy(param)
            resize!(_param, buffer_nparameter_new)
            @test length(_param.val) == length(_param.index) ==
                length(_param.result) == length(_param.weight ) == buffer_nparameter_new
            @test length(param.val) + buffer_newparam == length(_param.index)
            # Shuffle and check if correct
            __param = deepcopy(param)
            algs = [Alg(Res()) for _ in 1:buffer_nparameter]
            mods = [Mod(val) for _ in 1:buffer_nparameter]
            weights = collect(1.0:1:buffer_nparameter)
            shuffle!(__param, algs, mods, weights)
            @test __param.weight[end] == buffer_nparameter
        end
    end
end
