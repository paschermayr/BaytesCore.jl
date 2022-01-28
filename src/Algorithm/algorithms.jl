# This section defines functions that need to be overloaded so custom Algorithm works alongside other Algorithm with Baytes.
############################################################################################

#########################################
#!NOTE: New algorithm needs to be a subtype of AbstractAlgorithm, and functions for propose and propose! need to be provided.
"""
$(TYPEDEF)
Abstract super type for Algorithms. New algorithm needs to be subtype of `AbstractAlgorithm`.
"""
abstract type AbstractAlgorithm end

"""
    $(FUNCTIONNAME)
Propose new parameter with given algorithm, keeping objective fixed.

# Examples
```julia
propose(_rng::AbstractRNG, algorithm::AbstractAlgorithm, objective::AbstractObjective)
```

"""
function propose end

"""
    $(FUNCTIONNAME)
Inplace version of [`propose`](@ref).

# Examples
```julia
propose!(_rng::AbstractRNG, algorithm::AbstractAlgorithm, model::AbstractModelWrapper, data, temperature, update)
```

"""
function propose! end

#########################################
#NOTE: These functions are needed so sampler can communicate with eacher other in SMC. Not needed outside SMC.
"""
    $(FUNCTIONNAME)
Substitute result position in algorithm with new result.

# Examples
```julia
result!(algorithm::AbstractAlgorithm, result::AbstractResult)
```

"""
function result! end

"""
    $(FUNCTIONNAME)
Show log density result of algorithm.

# Examples
```julia
get_result(algorithm::AbstractAlgorithm)
```

"""
function get_result end

"""
    $(FUNCTIONNAME)
Get log objective result of algorithm.

# Examples
```julia
get_ℓweight(algorithm::AbstractAlgorithm)
```

"""
function get_ℓweight end

"""
    $(FUNCTIONNAME)
Get tagged parameter of AbstractAlgorithm..
"""
function get_tagged(algorithm::AbstractAlgorithm)
    return algorithm.tune.tagged
end

#########################################
#!NOTE: New Algorithm needs a constructor so given rng, model, data, chains, temperature, algorithm can be initiated.
"""
$(TYPEDEF)
Abstract type to construct Algorithms. New algorithm needs to define a functor to initiate corresponding `AbstractAlgorithm`.
"""
abstract type AbstractConstructor end

"""
    $(FUNCTIONNAME)
Return tagged symbol of AbstractConstructor.
"""
function get_sym(constructor::AbstractConstructor)
    return constructor.sym
end

#########################################
#!NOTE: New Algorithm needs to return a new model parameter and diagnostics that are a subtype of AbstractDiagnostics.
"""
$(TYPEDEF)
Abstract super type for Algorithm Diagnostics. Once `AbstractAlgorithm` has run, return new model parameter and `AbstractDiagnostics` of `AbstractAlgorithm`.
"""
abstract type AbstractDiagnostics end

"""
    $(FUNCTIONNAME)
Show results of input type, in this case a vector of `AbstractDiagnostics` of corresponding `AbstractAlgorithm`.

# Examples
```julia
results(diagnosticsᵛ::AbstractVector{AbstractDiagnostics}, algorithm, Ndigits, quantiles)
```

"""
function results end

"""
    $(FUNCTIONNAME)
Show values of Algorihm diagnostics.

# Examples
```julia
generate_showvalues(diagnostics::AbstractDiagnostics)
```

"""
function generate_showvalues end

"""
    $(FUNCTIONNAME)
Return prediction of AbstractAlgorithm diagnostics.

"""
function get_prediction(diagnostics::AbstractDiagnostics)
    return diagnostics.prediction
end

"""
    $(FUNCTIONNAME)
Infer output type from input. Infer `AbstractDiagnostics` from corresponding `AbstractAlgorithm`

# Examples
```julia
infer(_rng, diagnostics::Type{AbstractDiagnostics}, algorithm, model, data)
```

"""
function infer end

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
