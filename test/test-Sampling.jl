############################################################################################
############################################################################################
############################################################################################
# Diagnostics
@testset "Sampling - Diagnostics: " begin
    diag_ℓobjective = Float16(1.0)
    diag_temperature = Float32(0.5)
    diag_tmp = BaseDiagnostics(diag_ℓobjective, diag_temperature, nothing, 1)
    BaytesCore.get_prediction(diag_tmp)
    @test untemper(diag_tmp) == diag_ℓobjective*(1/diag_temperature)
end

############################################################################################
############################################################################################
############################################################################################
# Logging
@testset "Sampling - Logging: " begin
    logging_pr = ProgressReport(;bar=true, log=ConsoleLog())
    logging_sd = SampleDefault()
end

############################################################################################
############################################################################################
############################################################################################
# Resample
import Baytes: ResamplingMethod
@testset "Sampling - Resample: " begin
    struct Resamplingmethod1 <: ResamplingMethod end
    resample_bool = false
    resample_tune = ResampleTune(Resamplingmethod1(), Updater(resample_bool))
    update!(resample_tune)
    @test resample_tune.update.current != resample_bool
    init!(resample_tune, resample_bool)
    @test resample_tune.update.current == resample_bool
end

############################################################################################
############################################################################################
############################################################################################
# Shuffle

@testset "Sampling - Shuffle: " begin
    # Parameter
    shuffle_ndata = 10
    shuffle_nparticles = 5
    shuffle_lookback = 2
    shuffle_ancestors = [5, 4, 4, 3, 1]
    shuffle_anestorbuffer = zeros(Int64, shuffle_nparticles)

    shuffle_val = repeat(1:shuffle_nparticles, 1, shuffle_ndata)
    shuffle_valbuffer = zeros(Int64, shuffle_nparticles)

    shuffle_allancestors = repeat(1:shuffle_nparticles, 1, shuffle_ndata)
    for iter in 1:shuffle_nparticles
        shuffle_allancestors[iter, end] = shuffle_ancestors[iter]
    end


    # Basic shuffle! for last dimension
    shuffle_tmp = deepcopy(shuffle_val)
    shuffle!(shuffle_tmp, shuffle_buffer, shuffle_ancestors)
    @test sum( vec(sum(shuffle_tmp, dims=1)) .== sum(shuffle_ancestors) ) == shuffle_ndata

    # Shuffle_forward!
    shuffle_tmp = deepcopy(shuffle_val)
    shuffle_forward!(
        shuffle_tmp,
        shuffle_valbuffer,
        shuffle_allancestors,
        shuffle_anestorbuffer,
        shuffle_lookback, shuffle_ndata
    )
    @test shuffle_allancestors[1, shuffle_ndata] == shuffle_allancestors[end, shuffle_ndata-1]
    @test shuffle_tmp[1, shuffle_ndata] == shuffle_tmp[end, shuffle_ndata-shuffle_lookback]

    # Shuffle backward
    shuffle_tmp = deepcopy(shuffle_val)
    shuffle_backward!(
        shuffle_tmp,
        shuffle_valbuffer,
        shuffle_allancestors,
        shuffle_anestorbuffer
    )

end

############################################################################################
############################################################################################
############################################################################################
# Statistics

@testset "Sampling - Statistics: " begin
    accept_stat = AcceptStatistic

end

############################################################################################
############################################################################################
############################################################################################
# Weights

@testset "Sampling - Weights: " begin

end
