############################################################################################
############################################################################################
############################################################################################
# Chains

@testset "ChainsTune Configuration:" begin
    #Define Parameter
    chains_threshold = 0.5
    chains_coverage = 0.75
    chains_data_init = 200
    chains_Nchains_init = Int(floor(chains_data_init*chains_coverage))
    # Initiate
    chaintune = ChainsTune(chains_coverage, chains_threshold, chains_Nchains_init, chains_data_init)
    chainup_particles, chainup_data = update!(chaintune, chains_data_init + 1)
    #NOTE - Number of particles not updated for 1 additional data point
    @test chainup_particles isa UpdateFalse
    @test chainup_data isa UpdateTrue
    chainup_particles, chainup_data = update!(chaintune, chains_data_init + 2)
    #Note - 2 additional data points update Nparticles for chain_threshold == 0.5
    @test chainup_particles isa UpdateTrue
    @test chainup_data isa UpdateTrue
end


############################################################################################
############################################################################################
############################################################################################
# Data
data_config_uv = BaytesCore.ArrayConfig(data_uv)
data_config_mv = BaytesCore.ArrayConfig(data_mv)
data_config_mv2 = BaytesCore.ArrayConfig(data_mv2)
data_config_arbitrary = (data_uv, data_mv)


############################################################################################
@testset "Array Configuration:" begin
    ## Univariate Configuration
    @test data_config_uv.sorted isa BaytesCore.ByRows
    @test data_config_uv.size == (1000,)
    ## Multivariate - RowWise
    @test data_config_mv.sorted isa BaytesCore.ByRows
    @test data_config_mv.size == (500, 2)
    ## Multivariate - ColWise
    @test data_config_mv2.sorted isa BaytesCore.ByCols
    @test data_config_mv2.size == (2, 500)
end

############################################################################################
@testset "Data Structures - Univariate Array Configuration" begin
    ## Assign data structures
    data_batch = BaytesCore.Batch()
    data_subsampled = BaytesCore.SubSampled(N_initial)
    data_expanding = BaytesCore.Expanding(N_initial)
    data_rolling = BaytesCore.Rolling(N_initial)
    ## Assign DataTune
    tune_batch = BaytesCore.DataTune(data_batch, data_config_uv, nothing)
    tune_subsampled = BaytesCore.DataTune(data_subsampled, data_config_uv, nothing)
    tune_expanding = BaytesCore.DataTune(data_expanding, data_config_uv, nothing)
    tune_rolling = BaytesCore.DataTune(data_rolling, data_config_uv, nothing)
    tune_batch_arbitrarydata = BaytesCore.DataTune(data_config_arbitrary, Batch())
    # Other formats
    BaytesCore.DataTune(data_uv, data_batch)
    BaytesCore.DataTune(data_uv, data_subsampled)
    BaytesCore.DataTune(data_uv, data_expanding)
    BaytesCore.DataTune(data_uv, data_rolling)
    ## Check Data dimension
    @test size(BaytesCore.adjust(tune_batch, data_uv), 1) == size(data_uv, 1)
    @test size(BaytesCore.adjust(tune_subsampled, data_uv), 1) == N_initial
    @test size(BaytesCore.adjust(tune_expanding, data_uv), 1) == N_initial
    @test size(BaytesCore.adjust(tune_rolling, data_uv), 1) == N_initial
    @test size(BaytesCore.adjust(tune_batch_arbitrarydata, data_config_arbitrary), 1) == size(data_config_arbitrary, 1)
    ## Update data
    N_new = N_initial + 1
    BaytesCore.update!(_RNG, tune_batch)
    BaytesCore.update!(_RNG, tune_subsampled)
    BaytesCore.update!(_RNG, tune_expanding)
    BaytesCore.update!(_RNG, tune_rolling)
    BaytesCore.update!(_RNG, tune_batch_arbitrarydata)
    ## Check for new data index
    @test tune_expanding.structure.index.current == N_new
    @test tune_rolling.structure.index.current == N_new
    ## Check for new data dimension
    @test size(BaytesCore.adjust(tune_batch, data_uv), 1) == size(data_uv, 1)
    @test size(BaytesCore.adjust(tune_batch_arbitrarydata, data_config_arbitrary), 1) == size(data_config_arbitrary, 1)
    @test size(BaytesCore.adjust(tune_subsampled, data_uv), 1) == N_initial
    #!NOTE: Expanding Data Structure changes in size
    @test size(BaytesCore.adjust(tune_expanding, data_uv), 1) == N_new
    @test size(BaytesCore.adjust(tune_rolling, data_uv), 1) == N_initial
end

############################################################################################
@testset "Data Structures - Multivariate RowWise Array Configuration" begin
    ## Assign data structures
    data_batch = BaytesCore.Batch()
    data_subsampled = BaytesCore.SubSampled(N_initial)
    data_expanding = BaytesCore.Expanding(N_initial)
    data_rolling = BaytesCore.Rolling(N_initial)
    ## Assign DataTune
    tune_batch = BaytesCore.DataTune(data_batch, data_config_mv, nothing)
    tune_subsampled = BaytesCore.DataTune(data_subsampled, data_config_mv, nothing)
    tune_expanding = BaytesCore.DataTune(data_expanding, data_config_mv, nothing)
    tune_rolling = BaytesCore.DataTune(data_rolling, data_config_mv, nothing)
    BaytesCore.DataTune(data_mv, data_batch)
    BaytesCore.DataTune(data_mv, data_subsampled)
    BaytesCore.DataTune(data_mv, data_expanding)
    BaytesCore.DataTune(data_mv, data_rolling)
    ## Check Data dimension
    @test size(BaytesCore.adjust(tune_batch, data_mv)) == size(data_mv)
    @test size(BaytesCore.adjust(tune_subsampled, data_mv), 1) == N_initial
    @test size(BaytesCore.adjust(tune_expanding, data_mv), 1) == N_initial
    @test size(BaytesCore.adjust(tune_rolling, data_mv), 1) == N_initial
    ## Update data
    N_new = N_initial + 1
    BaytesCore.update!(_RNG, tune_batch)
    BaytesCore.update!(_RNG, tune_subsampled)
    BaytesCore.update!(_RNG, tune_expanding)
    BaytesCore.update!(_RNG, tune_rolling)
    ## Check for new data index
    @test tune_expanding.structure.index.current == N_new
    @test tune_rolling.structure.index.current == N_new
    ## Check for new data dimension
    @test size(BaytesCore.adjust(tune_batch, data_mv)) == size(data_mv)
    @test size(BaytesCore.adjust(tune_subsampled, data_mv), 1) == N_initial
    #!NOTE: Expanding Data Structure changes in size
    @test size(BaytesCore.adjust(tune_expanding, data_mv), 1) == N_new
    @test size(BaytesCore.adjust(tune_rolling, data_mv), 1) == N_initial
end

############################################################################################
@testset "Data Structures - Multivariate ColWise Array Configuration" begin
    ## Assign data structures
    data_batch = BaytesCore.Batch()
    data_subsampled = BaytesCore.SubSampled(N_initial)
    data_expanding = BaytesCore.Expanding(N_initial)
    data_rolling = BaytesCore.Rolling(N_initial)
    ## Assign DataTune
    tune_batch = BaytesCore.DataTune(data_batch, data_config_mv2, nothing)
    tune_subsampled = BaytesCore.DataTune(data_subsampled, data_config_mv2, nothing)
    tune_expanding = BaytesCore.DataTune(data_expanding, data_config_mv2, nothing)
    tune_rolling = BaytesCore.DataTune(data_rolling, data_config_mv2, nothing)
    ## Check Data dimension
    @test size(BaytesCore.adjust(tune_batch, data_mv2)) == size(data_mv2)
    @test size(BaytesCore.adjust(tune_subsampled, data_mv2), 2) == N_initial
    @test size(BaytesCore.adjust(tune_expanding, data_mv2), 2) == N_initial
    @test size(BaytesCore.adjust(tune_rolling, data_mv2), 2) == N_initial
    ## Update data
    N_new = N_initial + 1
    BaytesCore.update!(_RNG, tune_batch)
    BaytesCore.update!(_RNG, tune_subsampled)
    BaytesCore.update!(_RNG, tune_expanding)
    BaytesCore.update!(_RNG, tune_rolling)
    ## Check for new data index
    @test tune_expanding.structure.index.current == N_new
    @test tune_rolling.structure.index.current == N_new
    ## Check for new data dimension
    @test size(BaytesCore.adjust(tune_batch, data_mv2)) == size(data_mv2)
    @test size(BaytesCore.adjust(tune_subsampled, data_mv2), 2) == N_initial
    #!NOTE: Expanding Data Structure changes in size
    @test size(BaytesCore.adjust(tune_expanding, data_mv2), 2) == N_new
    @test size(BaytesCore.adjust(tune_rolling, data_mv2), 2) == N_initial
end

############################################################################################
############################################################################################
############################################################################################
# generated
@testset "Generated functions:" begin
    # Initiate test cases
    struct gen_struct
        a
        b
    end
    generated_struct = gen_struct(1,2)
    generated_nt = (a = 1., b = [2, 3], c = [4. 5 ; 6 7], d = [[8, 9], [10, 11]])
    generated_subset = (:a, :b)
    generated_sym = :c
    #
    generated_tmp = BaytesCore.subset(generated_nt, generated_subset)
    @test length(generated_tmp) == length(generated_subset)
    generated_tmp2 = BaytesCore.subset(generated_nt, generated_sym)
    @test length(generated_tmp2) == 1
    generated_tmp3 = BaytesCore.Tuple_to_Namedtuple(generated_subset, true)
    @test length(generated_tmp3) == length(generated_subset)
    generated_tmp4 = BaytesCore.to_NamedTuple_generated(generated_struct)
    @test generated_tmp4 isa NamedTuple
end

############################################################################################
############################################################################################
############################################################################################
# helper
@testset "Helper functions:" begin

    # Updater
    helper_update = Updater(false)
    update!(helper_update)
    @test helper_update.current == true
    init!(helper_update, false)
    @test helper_update.current == false

    # ValueHolder
    helper_valholder = ValueHolder(1.0)
    @test helper_valholder.current == 1.0
    update!(helper_valholder, 2.0)
    @test helper_valholder.current == 2.0
    init!(helper_valholder, 3.0)
    @test helper_valholder.current == 3.0

    # Iterator
    helper_iterator = Iterator(3)
    @test helper_iterator.current == 3
    update!(helper_iterator)
    @test helper_iterator.current == 4
    init!(helper_iterator, 6)
    @test helper_iterator.current == 6

    # Accumulator
    helper_accumulator = Accumulator()
    update!(helper_accumulator, 1.0)
    @test helper_accumulator.current == helper_accumulator.cumulative == 1.0
    update!(helper_accumulator, 1.5)
    @test helper_accumulator.current == 1.5
    @test helper_accumulator.cumulative == 2.5
    init!(helper_accumulator)
    @test helper_accumulator.current == helper_accumulator.cumulative == 0.0
end

############################################################################################
############################################################################################
############################################################################################
# jitter
