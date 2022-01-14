############################################################################################
"""
$(TYPEDEF)
Holds tuning information for number of chains in comparison to data.

# Fields
$(TYPEDFIELDS)
"""
mutable struct ChainsTune
    "Proposed coverage of number of chains/number of data points."
    coverage::Float64
    "Threshold for resampling, between 0.00 and 1.00."
    threshold::Float64
    "Number of chains."
    Nchains::Int64
    "Number of data points."
    Ndata::Int64
    function ChainsTune(
        coverage::Float64,
        threshold::Float64,
        Nchains::Int64,
        Ndata::Int64
    )
        ArgCheck.@argcheck coverage > 0.0 "Coverage needs to be positive"
        ArgCheck.@argcheck Nchains > 0 "Nchains needs to be positive"
        ArgCheck.@argcheck Ndata > 0 "Ndata needs to be positive"
        ArgCheck.@argcheck threshold >= 0.0 "Threshold needs to be positive"
        return new(coverage, threshold, Nchains, Ndata)
    end
end

############################################################################################
function update!(ptune::ChainsTune, Ndata::Integer)
    ## Check if data size has changed
    update_Ndata = ptune.Ndata != Ndata ? UpdateTrue() : UpdateFalse()
    if update_Ndata isa UpdateTrue
        ptune.Ndata = Ndata
    end
    ## Check if chains size has changed
    Nchainsᵖ = Int64(floor(ptune.coverage * Ndata))
    #!NOTE: Update Nchains if coverage falls below data size.
    update_Nchains = ptune.Nchains != Nchainsᵖ ? UpdateTrue() : UpdateFalse()
    @inbounds if update_Nchains isa UpdateTrue
        ptune.Nchains = Nchainsᵖ
    end
    return update_Nchains, update_Ndata
end

############################################################################################
#export
export ChainsTune
