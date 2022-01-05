############################################################################################
# Define functions to dispatch on Algorithms
"""
    $(FUNCTIONNAME)
Infer output type from input
"""
function infer end

"""
    $(FUNCTIONNAME)
Show results of input type.
"""
function results end

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

"""
    $(FUNCTIONNAME)
Initialize struct.
"""
function init end

"""
    $(FUNCTIONNAME)
Inplace version of [`init`](@ref).
"""
function init! end

"""
    $(FUNCTIONNAME)
Propose new parameter with given algorithm.
"""
function propose end

"""
    $(FUNCTIONNAME)
Inplace version of [`propose`](@ref).
"""
function propose! end

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

"""
    $(FUNCTIONNAME)
Update tuning container
"""
function adapt end

"""
    $(FUNCTIONNAME)
Inplace version of [`adapt`](@ref).
"""
function adapt! end

############################################################################################
"Some functions to be dispatched for various Algorithms to guarantee return types"

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

############################################################################################
#export
