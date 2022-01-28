#!NOTE: This section defines functions that need to be overloaded in order for custom Kernel inside an existing Baytes AbstractAlgorithm to work with corresponding Baytes package.
############################################################################################

#########################################
"""
$(TYPEDEF)
Abstract super type for Algorithm Kernels. New Kernels needs to be inside corresponding `AbstractAlgorithm`.
"""
abstract type AbstractKernel end

"""
    $(FUNCTIONNAME)
Propagate algorithm one step forward.
"""
function propagate end

"""
    $(FUNCTIONNAME)
Inplace version of [`propagate`](@ref).
"""
function propagate! end

function infer end

"""
    $(FUNCTIONNAME)
Initialize struct.
"""
function init end


############################################################################################
# Export
export
    AbstractKernel,
    propagate,
    propagate!,
    init,
    infer
