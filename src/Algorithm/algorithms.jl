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

#NOTE: These functions are needed so sampler can communicate with eacher other in SMC.
"""
    $(FUNCTIONNAME)
Substitute result position in algorithm with new result.
"""
function result! end

"""
    $(FUNCTIONNAME)
Show log density result of algorithm.
"""
function get_result end
"""
    $(FUNCTIONNAME)
Get log objective function of algorithm..
"""
function get_ℓweight end

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

"""
    $(FUNCTIONNAME)
Show values of Algorihm diagnostics.
"""
function generate_showvalues end

"""
    $(FUNCTIONNAME)
Return prediction of AbstractAlgorithm diagnostics.
"""
function get_prediction end

#########################################



"""
    $(FUNCTIONNAME)
Show tagged parameter.
"""
function get_tagged end

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
