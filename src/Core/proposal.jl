############################################################################################
"""
$(TYPEDEF)
Proposal function tuning struct.

Contains information for proposal step of algorithm that is on a higher level and shared among different sampler, like data indexing, and is not stored in algorithm struct.

# Fields
$(TYPEDFIELDS)
"""
struct ProposalTune{F<:Real, U<:UpdateBool, T<:DataTune}
    "Temperature for log objective tempering."
	temperature    ::  F
    "Quasi-Boolean if Algorithm has to be updated with new parameter before proposal step."
	update         ::  U
    "Information at which iteration data indexing is at the moment."
	datatune       ::  T
    function ProposalTune(
        temperature::F,
        update::U,
        datatune::T,
    ) where {F<:Real, U<:UpdateBool, T<:DataTune}
        ArgCheck.@argcheck 0.0 <= temperature <= 1.0
        ## Return ProposalTune
        return new{F, U, T}(temperature, update, datatune)
    end
end

function ProposalTune(temperature::F) where {F<:Real}
    return ProposalTune(temperature, UpdateTrue(), DataTune(Batch(), nothing, nothing) )
end

############################################################################################
#export
export ProposalTune
