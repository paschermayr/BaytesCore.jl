############################################################################################
############################################################################################
############################################################################################
# Tempering

@testset "Tempering - Iteration Tempering: " begin
    #Define Parameter
    itertemper_type = Float16
    itertemper_adaption = UpdateTrue()
    itertemper_val = Float32(0.5)
    itertemper_iter = 1000
    ## Adaptive Case
    itertemper_tune = IterationTempering(
        itertemper_type,
        itertemper_adaption,
        itertemper_val,
        itertemper_iter
    )
    temps = BaytesCore.checktemperature(itertemper_tune.parameter, itertemper_iter)
    @test all( temps[iter] >= temps[iter-1] for iter in 2:itertemper_iter)
    @test itertemper_tune.initial.current isa itertemper_type
    @test itertemper_tune.parameter.L isa itertemper_type
    # Update temperature
    @test initial(itertemper_tune) == itertemper_tune.initial.current
    itertemper_tmp = update!(itertemper_tune, 2)
    @test itertemper_tmp > itertemper_tune.initial.current
    ## Fixed stepsize
    itertemper_tune = IterationTempering(
        itertemper_type,
        UpdateFalse(),
        itertemper_val,
        itertemper_iter
    )
    @test itertemper_tune.initial.current isa itertemper_type
    @test itertemper_tune.initial.current == itertemper_val
    @test itertemper_tune.parameter.L isa itertemper_type
    # Update temperature
    @test initial(itertemper_tune) == itertemper_tune.initial.current
    itertemper_tmp = update!(itertemper_tune, 2)
    @test itertemper_tmp == itertemper_tune.initial.current
end

@testset "Tempering - Joint Tempering: " begin
    # Initial Parameter
    jointtemper_type = Float16
    jointtemper_adaption = UpdateTrue()
    jointtemper_unnormalizedweights = [.1, .2, .3, .4, .5]
    jointtemper_weights = jointtemper_unnormalizedweights ./ sum(jointtemper_unnormalizedweights)
    jointtemper_λ₀ = 0.5
    jointtemper_ESS = Float64(length(jointtemper_weights))
    # Test if weights are incrementally increasing
    @test BaytesCore.weightedESS(jointtemper_weights, 1., 1.) == length(jointtemper_weights)
    jointtemper_essdiff = BaytesCore.get_ESSDifference(jointtemper_weights, jointtemper_λ₀, jointtemper_ESS)
    @test jointtemper_essdiff(jointtemper_λ₀ + 0.01) >= 0.0
    jointtemper_newval = update(jointtemper_weights, jointtemper_λ₀, jointtemper_ESS)
    @test jointtemper_newval >= jointtemper_λ₀
    @test update(jointtemper_weights, 1.0, jointtemper_ESS) ≈ 1.0 atol = _TOL
    ## Adaptive joint tempering
    jointtemper_tune = JointTempering(
        jointtemper_type,
        jointtemper_adaption,
        jointtemper_λ₀,
        jointtemper_ESS,
        length(jointtemper_weights)
    )
    initial(jointtemper_tune)
    @test typeof(jointtemper_tune.val.current) == typeof(jointtemper_tune.ESSTarget.current) == jointtemper_type
    @test eltype(jointtemper_tune.weights) == jointtemper_type
    # Check for Updates
    update!(jointtemper_tune, log.(jointtemper_unnormalizedweights))
    @test jointtemper_tune.val.current > jointtemper_λ₀
    @test sum(jointtemper_tune.weights) ≈ 1.0

    ## Fixed joint tempering
    jointtemper_tune = JointTempering(
        jointtemper_type,
        UpdateFalse(),
        jointtemper_λ₀,
        jointtemper_ESS,
        length(jointtemper_weights)
    )
    @test typeof(jointtemper_tune.val.current) == typeof(jointtemper_tune.ESSTarget.current) == jointtemper_type
    @test eltype(jointtemper_tune.weights) == jointtemper_type
    # Check for Updates
    update!(jointtemper_tune, log.(jointtemper_unnormalizedweights))
    @test jointtemper_tune.val.current == jointtemper_λ₀
end
