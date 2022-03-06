############################################################################################
# Data
config_uv = BaytesCore.ArrayConfig(data_uv)
config_mv = BaytesCore.ArrayConfig(data_mv)
config_mv2 = BaytesCore.ArrayConfig(data_mv2)

config_arbitrary = (data_uv, data_mv)

############################################################################################
@testset "Array Configuration:" begin
    ## Univariate Configuration
    @test config_uv.sorted isa BaytesCore.ByRows
    @test config_uv.size == (1000,)
    ## Multivariate - RowWise
    @test config_mv.sorted isa BaytesCore.ByRows
    @test config_mv.size == (500, 2)
    ## Multivariate - ColWise
    @test config_mv2.sorted isa BaytesCore.ByCols
    @test config_mv2.size == (2, 500)
end

############################################################################################
@testset "Data Structures - Univariate Array Configuration" begin
    ## Assign data structures
    data_batch = BaytesCore.Batch()
    data_subsampled = BaytesCore.SubSampled(N_initial)
    data_expanding = BaytesCore.Expanding(N_initial)
    data_rolling = BaytesCore.Rolling(N_initial)
    ## Assign DataTune
    tune_batch = BaytesCore.DataTune(data_batch, config_uv, nothing)
    tune_subsampled = BaytesCore.DataTune(data_subsampled, config_uv, nothing)
    tune_expanding = BaytesCore.DataTune(data_expanding, config_uv, nothing)
    tune_rolling = BaytesCore.DataTune(data_rolling, config_uv, nothing)
    tune_batch_arbitrarydata = BaytesCore.DataTune(config_arbitrary, Batch())
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
    @test size(BaytesCore.adjust(tune_batch_arbitrarydata, config_arbitrary), 1) == size(config_arbitrary, 1)
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
    @test size(BaytesCore.adjust(tune_batch_arbitrarydata, config_arbitrary), 1) == size(config_arbitrary, 1)
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
    tune_batch = BaytesCore.DataTune(data_batch, config_mv, nothing)
    tune_subsampled = BaytesCore.DataTune(data_subsampled, config_mv, nothing)
    tune_expanding = BaytesCore.DataTune(data_expanding, config_mv, nothing)
    tune_rolling = BaytesCore.DataTune(data_rolling, config_mv, nothing)
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
    tune_batch = BaytesCore.DataTune(data_batch, config_mv2, nothing)
    tune_subsampled = BaytesCore.DataTune(data_subsampled, config_mv2, nothing)
    tune_expanding = BaytesCore.DataTune(data_expanding, config_mv2, nothing)
    tune_rolling = BaytesCore.DataTune(data_rolling, config_mv2, nothing)
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
