############################################################################################
"""
$(TYPEDEF)

Default arguments for printing summary statistics after sampling.

# Fields
$(TYPEDFIELDS)
"""
struct PrintDefault
    "Number of Digits for rounding summary statistics."
    Ndigits::Int64
    "Quantiles for summary statistics."
    quantiles::Vector{Float64}
    function PrintDefault(; Ndigits=3, quantiles=[0.025, 0.25, 0.50, 0.75, 0.975])
        ArgCheck.@argcheck 0 < Ndigits
        ArgCheck.@argcheck all(
            0.0 <= quantiles[iter] <= 1.0 for iter in eachindex(quantiles)
        ) "Quantiles should be between 0.0 and 1.0."
        return new(Ndigits, quantiles)
    end
end


############################################################################################
# Export
export PrintDefault
