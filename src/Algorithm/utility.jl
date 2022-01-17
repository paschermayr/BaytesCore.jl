# This section defines utility functions/structs that are used throughout Baytes, but do not need to be extended
############################################################################################

#########################################
"""
$(TYPEDEF)
Abstract super type for Tuning Algorithms.
"""
abstract type AbstractTune end

#########################################
"""
$(TYPEDEF)
Lower level configuration for individual Algorithms.
"""
abstract type AbstractConfiguration end

#########################################
function init end

"""
    $(FUNCTIONNAME)
Inplace version of [`init`](@ref).
"""
function init! end

"""
    $(FUNCTIONNAME)
Update struct and return new type.
"""
function update end

"""
    $(FUNCTIONNAME)
Update fields of existing struct.
"""
function update! end

############################################################################################
# Export
export
    AbstractTune,
    AbstractDiagnostics,
    AbstractConfiguration,

    init,
    init!,
    update,
    update!
