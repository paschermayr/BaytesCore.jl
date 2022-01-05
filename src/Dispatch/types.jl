############################################################################################
# Define super types that are used in various algorithms
"""
$(TYPEDEF)
Abstract super type for Algorithms.
"""
abstract type AbstractAlgorithm end
"""
$(TYPEDEF)
Abstract super type for Tuning Algorithms.
"""
abstract type AbstractTune end
"""
$(TYPEDEF)
Abstract super type for Algorithm Diagnostics.
"""
abstract type AbstractDiagnostics end
"""
$(TYPEDEF)
Abstract super type for Algorithm Kernels.
"""
abstract type AbstractKernel end
"""
$(TYPEDEF)
Lower level configuration for individual Algorithms.
"""
abstract type AbstractConfiguration end
"""
$(TYPEDEF)
Abstract type to construct Algorithms.
"""
abstract type AbstractConstructor end

############################################################################################
#export
