############################################################################################
abstract type ProgressLog end
struct SilentLog <: ProgressLog end
struct ConsoleLog <: ProgressLog end

"""
$(TYPEDEF)

Default arguments for logging sampling output during sampling process.

# Fields
$(TYPEDFIELDS)
"""
struct ProgressReport{P<:ProgressLog,K}
    "Boolean if progressbar enabled during sampling run"
    bar::Bool
    "Boolean if output diagnostics should be printed."
    log::P
    "Additional ProgressMeter keywords to be used to return output"
    kwargs::K
    function ProgressReport(;
        bar=true,
        log=SilentLog(),
        kwargs=(dt=0.1, desc="Computing...", color=:blue, showspeed=true),
    )
        if isa(log, ConsoleLog)
            ArgCheck.@argcheck bar "Log can only be printed if bar == true."
        end
        return new{typeof(log),typeof(kwargs)}(bar, log, kwargs)
    end
end

############################################################################################
"""
$(TYPEDEF)

Default arguments for sampling routine.

# Fields
$(TYPEDFIELDS)
"""
struct SampleDefault{
    D<:DataStructure,
    M<:TemperingMethod,
    P<:ProgressReport
    }
    "Format to split data before proposal step."
    dataformat::D
    "Tempering values for target distributions of each chain, per default = 1*logtarget(θ | data) for each chain"
    tempering::M
    "Number of chains run in sampling step."
    chains::Int64
    "Number of MCMC iterations. May be overwritten in SMC."
    iterations::Int64
    "Burn in samples."
    burnin::Int64
    "Boolean if trace and algorithm should be safed to working directory."
    safeoutput::Bool
    "Boolean if summary statistics should be calculated."
    printoutput::Bool
    "Default arguments for printing summary statistics"
    printdefault::PrintDefault
    "Default arguments for printing output during sampling runs"
    report::P
    function SampleDefault(;
        dataformat=Batch(),
        tempering=IterationTempering(Float64, UpdateFalse(), 1.0, 1000),
        chains=4,
        iterations=2000,
        burnin=max(1, Int64(floor(iterations / 10))),
        safeoutput=false,
        printoutput=true,
        printdefault=PrintDefault(),
        report=ProgressReport(),
    )
        ArgCheck.@argcheck 0 < chains
        ArgCheck.@argcheck 0 <= burnin < iterations
        return new{
        typeof(dataformat), typeof(tempering), typeof(report)
        }(
            dataformat,
            tempering,
            chains,
            iterations,
            burnin,
            safeoutput,
            printoutput,
            printdefault,
            report,
        )
    end
end

############################################################################################
# Export
export
    ProgressLog,
    SilentLog,
    ConsoleLog,
    ProgressReport,
    SampleDefault
