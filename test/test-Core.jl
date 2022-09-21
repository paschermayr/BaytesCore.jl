############################################################################################
############################################################################################
############################################################################################
# Chains

@testset "Core - ChainsTune Configuration:" begin
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
@testset "Core - Array Configuration:" begin
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
@testset "Core - Data Structures - Univariate Array Configuration" begin
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

    @test size(BaytesCore.adjust_previous(tune_batch, data_uv), 1) == size(data_uv, 1)
    @test size(BaytesCore.adjust_previous(tune_subsampled, data_uv), 1) == N_initial
    @test size(BaytesCore.adjust_previous(tune_expanding, data_uv), 1) == N_initial-1
    @test size(BaytesCore.adjust_previous(tune_rolling, data_uv), 1) == N_initial-1

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

    @test size(BaytesCore.adjust_previous(tune_expanding, data_uv), 1) == N_new-1
    @test size(BaytesCore.adjust_previous(tune_rolling, data_uv), 1) == N_initial

    BaytesCore.update!(_RNG, tune_expanding)
    BaytesCore.update!(_RNG, tune_rolling)
    N_new2 = N_new + 1
    @test size(BaytesCore.adjust_previous(tune_expanding, data_uv), 1) == N_new2-1
    @test size(BaytesCore.adjust_previous(tune_rolling, data_uv), 1) == N_initial
end

############################################################################################
@testset "Core - Data Structures - Multivariate RowWise Array Configuration" begin
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

    @test size(BaytesCore.adjust_previous(tune_batch, data_mv)) == size(data_mv)
    @test size(BaytesCore.adjust_previous(tune_subsampled, data_mv), 1) == N_initial
    @test size(BaytesCore.adjust_previous(tune_expanding, data_mv), 1) == N_initial-1
    @test size(BaytesCore.adjust_previous(tune_rolling, data_mv), 1) == N_initial-1

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

    @test size(BaytesCore.adjust_previous(tune_expanding, data_mv), 1) == N_new-1
    @test size(BaytesCore.adjust_previous(tune_rolling, data_mv), 1) == N_initial

    BaytesCore.update!(_RNG, tune_expanding)
    BaytesCore.update!(_RNG, tune_rolling)
    N_new2 = N_new + 1
    @test size(BaytesCore.adjust_previous(tune_expanding, data_mv), 1) == N_new2-1
    @test size(BaytesCore.adjust_previous(tune_rolling, data_mv), 1) == N_initial
end

############################################################################################
@testset "Core - Data Structures - Multivariate ColWise Array Configuration" begin
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

    @test size(BaytesCore.adjust_previous(tune_batch, data_mv2)) == size(data_mv2)
    @test size(BaytesCore.adjust_previous(tune_subsampled, data_mv2), 2) == N_initial
    @test size(BaytesCore.adjust_previous(tune_expanding, data_mv2), 2) == N_initial-1
    @test size(BaytesCore.adjust_previous(tune_rolling, data_mv2), 2) == N_initial-1

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

    @test size(BaytesCore.adjust_previous(tune_expanding, data_mv2), 2) == N_new-1
    @test size(BaytesCore.adjust_previous(tune_rolling, data_mv2), 2) == N_initial

    BaytesCore.update!(_RNG, tune_expanding)
    BaytesCore.update!(_RNG, tune_rolling)
    N_new2 = N_new + 1
    @test size(BaytesCore.adjust_previous(tune_expanding, data_mv2), 2) == N_new2-1
    @test size(BaytesCore.adjust_previous(tune_rolling, data_mv2), 2) == N_initial

end

############################################################################################
############################################################################################
############################################################################################
# generated
@testset "Core - Generated functions:" begin
    # Initiate test cases
    struct gen_struct
        a
        b
    end
    generated_struct = gen_struct(1,2)
    generated_nt = (a = 1., b = [2, 3], c = [4. 5 ; 6 7], d = [[8, 9], [10, 11]])
    generated_vec = [1., [2, 3], [4. 5 ; 6 7], [[8, 9], [10, 11]]]
    generated_subset = (:a, :b)
    generated_sym = :c
    #
    _ntup = BaytesCore.to_NamedTuple(keys(generated_nt), generated_vec)
    @test _ntup isa NamedTuple
    _tup = BaytesCore.to_Tuple_generated(generated_struct)
    @test _tup isa Tuple
    #
    sym = BaytesCore.Tuple_to_Namedtuple(generated_subset, true)
    @test sym isa NamedTuple
    _ntup2 = BaytesCore.subset(_ntup, sym)
    @test _ntup2 isa NamedTuple
    @test keys(_ntup2) == keys(sym) == generated_subset
    BaytesCore.keyunion(generated_nt, _ntup2)
    #
    generated_tmp = BaytesCore.subset(generated_nt, generated_subset)
    @test length(generated_tmp) == length(generated_subset)
    generated_tmp2 = BaytesCore.subset(generated_nt, generated_sym)
    @test length(generated_tmp2) == 1
    generated_tmp3 = BaytesCore.Tuple_to_Namedtuple(generated_subset, true)
    @test length(generated_tmp3) == length(generated_subset)
    generated_tmp4 = BaytesCore.to_NamedTuple_generated(generated_struct)
    @test generated_tmp4 isa NamedTuple
    #
    generated_tup1 = BaytesCore.to_Tuple(generated_subset)
    generated_tup2 = BaytesCore.to_Tuple(generated_sym)
    @test generated_tup1 isa Tuple
    @test generated_tup2 isa Tuple
end

############################################################################################
############################################################################################
############################################################################################
# helper
@testset "Core - Helper functions:" begin

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
@testset "Core - Jitter functions:" begin
    jitter_adaption = UpdateTrue()
    jitter_threshold = 0.5
    jitter_min = 2
    jitter_max = 10

    ## Adaptive Jittering
    jitter_tune = JitterTune(
        jitter_adaption,
        jitter_threshold,
        jitter_min,
        jitter_max
    )
    @test jitter_tune.Nsteps.current == 0
    # Jitter
    jitter_continue = jitter!(jitter_tune, jitter_threshold + 0.1)
    @test jitter_tune.Nsteps.current == 1
    @test jitter_continue == true
    jitter_continue = jitter!(jitter_tune, jitter_threshold - 0.1)
    @test jitter_tune.Nsteps.current == 2
    @test jitter_continue == false
    #Fall back to 0
    update!(jitter_tune)
    @test jitter_tune.Nsteps.current == 0

    ## Fixed number of Jittering steps
    jitter_tune = JitterTune(
        UpdateFalse(),
        jitter_threshold,
        jitter_min,
        3
    )
    # Jitter
    jitter_continue = jitter!(jitter_tune, jitter_threshold + 0.1)
    @test jitter_tune.Nsteps.current == 1
    @test jitter_continue == true
    jitter_continue = jitter!(jitter_tune, jitter_threshold - 0.1)
    @test jitter_tune.Nsteps.current == 2
    @test jitter_continue == true
    jitter_continue = jitter!(jitter_tune, jitter_threshold - 0.1)
    @test jitter_tune.Nsteps.current == 3
    @test jitter_continue == false
    #Fall back to 0
    update!(jitter_tune)
    @test jitter_tune.Nsteps.current == 0
end

############################################################################################
############################################################################################
############################################################################################
# Printing
@testset "Core - Printing functions:" begin
end

############################################################################################
############################################################################################
############################################################################################
# Proposal
@testset "Core - ProposalTune functions:" begin

    @test ProposalTune(1.0) isa ProposalTune
    @test ProposalTune(0.0) isa ProposalTune

    @test_throws ArgumentError("temperature <= 1.0 must hold. Got\ntemperature => 2.0") ProposalTune(2.0)
    @test_throws ArgumentError("0.0 <= temperature must hold. Got\ntemperature => -2.0") ProposalTune(-2.0)

end

############################################################################################
############################################################################################
############################################################################################
# Utility
@testset "Core - Utility functions:" begin
    utility_arr = [0.0, 1.0, 2.0]
    utility_xinf = [1., 2., Inf]
    @test logmeanexp(utility_arr) ≈ log(mean(exp.(utility_arr)))
    @test BaytesCore.logaddexp(utility_xinf[1], utility_xinf[2]) ≈ log(sum(exp.(utility_xinf[1:2])))
    @test BaytesCore.logaddexp(utility_xinf[2], utility_xinf[3]) ≈ log(sum(exp.(utility_xinf[2:3])))
    @test BaytesCore.logaddexp(utility_xinf[2], utility_xinf[1]) ≈ log(sum(exp.(utility_xinf[1:2])))
    @test BaytesCore.logaddexp(utility_xinf[3], utility_xinf[2]) ≈ log(sum(exp.(utility_xinf[2:3])))

    #!NOTE: threshold is second argument
    @test issmaller(utility_xinf[1], utility_xinf[2]) == true
    @test issmaller(utility_xinf[2], utility_xinf[1]) == false
    @test issmaller(utility_xinf[2], utility_xinf[3]) == true
end


@testset "Core - Utility functions: grab " begin

    grab_iter = 3
    grab_idx = 1:6
    grab_idx2 = 1:3
    grab_ncols = 5
    grab_nrows = 10
## Vector
    @test grab(nothing, nothing, nothing) isa Nothing
    grab_data = zeros(grab_nrows)
    # Sorted by rows
    grab_sorted = BaytesCore.ByRows()
    grab_tmp = grab(grab_data, grab_iter, grab_sorted)
    @test length(grab_tmp) == 1
    grab_tmp = grab(grab_data, grab_idx, grab_sorted)
    @test length(grab_tmp) == length(grab_idx)
    # Sorted by Cols
    grab_sorted = BaytesCore.ByCols()
    grab_tmp = grab(grab_data, grab_iter, grab_sorted)
    @test length(grab_tmp) == 1
    grab_tmp = grab(grab_data, grab_idx2, grab_sorted)
    @test length(grab_tmp) == length(grab_idx2)
## Matrix
    grab_data = zeros(grab_nrows, grab_ncols)
    # Sorted by rows
    grab_sorted = BaytesCore.ByRows()
    grab_tmp = grab(grab_data, grab_iter, grab_sorted)
    @test length(grab_tmp) == grab_ncols
    grab_tmp = grab(grab_data, grab_idx, grab_sorted)
    @test size(grab_tmp) == (length(grab_idx), grab_ncols)
    # Sorted by Cols
    grab_sorted = BaytesCore.ByCols()
    grab_tmp = grab(grab_data, grab_iter, grab_sorted)
    @test length(grab_tmp) == grab_nrows
    grab_tmp = grab(grab_data, grab_idx2, grab_sorted)
    @test size(grab_tmp) == (grab_nrows, length(grab_idx2))

end
