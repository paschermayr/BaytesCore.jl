# This section defines functions that need to be overloaded so custom Algorithm works alongside other Algorithm with Baytes.
############################################################################################

#########################################
"""
$(TYPEDEF)
Abstract super type for Algorithms. New algorithm needs to be subtype of `AbstractAlgorithm`.
"""
abstract type AbstractAlgorithm end

"""
    $(FUNCTIONNAME)
Propose new parameter with given algorithm, keeping objective fixed.
"""
function propose end

"""
    $(FUNCTIONNAME)
Inplace version of [`propose`](@ref).
"""
function propose! end

"""
    $(FUNCTIONNAME)
Substitute result with new result.
"""
function result! end

"""
    $(FUNCTIONNAME)
Show log density result.
"""
function get_result end

"""
    $(FUNCTIONNAME)
Show tagged parameter.
"""
function get_tagged end

"""
    $(FUNCTIONNAME)
Get log likelihood of sampler combination.
"""
function get_loglik end

"""
    $(FUNCTIONNAME)
Get predictions of sampler combination.
"""
function get_prediction end

"""
    $(FUNCTIONNAME)
Get phase tune struct of sampler combination.
"""
function get_phase end

"""
    $(FUNCTIONNAME)
Get current iteration of sampler combination.
"""
function get_iteration end

"""
    $(FUNCTIONNAME)
Show values of Algorihm diagnostics.
"""
function generate_showvalues end

#########################################
"""
$(TYPEDEF)
Abstract type to construct Algorithms. New algorithm needs to define a functor to initiate corresponding `AbstractAlgorithm`.
"""
abstract type AbstractConstructor end

#########################################
"""
$(TYPEDEF)
Abstract super type for Algorithm Diagnostics. Once `AbstractAlgorithm` has run, return new model parameter and `AbstractDiagnostics` of `AbstractAlgorithm`.
"""
abstract type AbstractDiagnostics end

"""
    $(FUNCTIONNAME)
Infer output type from input. Infer `AbstractDiagnostics` from corresponding `AbstractAlgorithm`
"""
function infer end

"""
    $(FUNCTIONNAME)
Show results of input type, in this case a vector of `AbstractDiagnostics` of corresponding `AbstractAlgorithm`.
"""
function results end

############################################################################################
# Export
export
    AbstractAlgorithm,
    propose,
    propose!,

    AbstractConstructor,

    AbstractDiagnostics,
    infer,
    results
