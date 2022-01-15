var documenterSearchIndex = {"docs":
[{"location":"intro/#Introduction","page":"Introduction","title":"Introduction","text":"","category":"section"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"Yet to be properly done.","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = BaytesCore","category":"page"},{"location":"#BaytesCore","page":"Home","title":"BaytesCore","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for BaytesCore.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [BaytesCore]","category":"page"},{"location":"#BaytesCore.AbstractAlgorithm","page":"Home","title":"BaytesCore.AbstractAlgorithm","text":"abstract type AbstractAlgorithm\n\nAbstract super type for Algorithms.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.AbstractConfiguration","page":"Home","title":"BaytesCore.AbstractConfiguration","text":"abstract type AbstractConfiguration\n\nLower level configuration for individual Algorithms.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.AbstractConstructor","page":"Home","title":"BaytesCore.AbstractConstructor","text":"abstract type AbstractConstructor\n\nAbstract type to construct Algorithms.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.AbstractDiagnostics","page":"Home","title":"BaytesCore.AbstractDiagnostics","text":"abstract type AbstractDiagnostics\n\nAbstract super type for Algorithm Diagnostics.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.AbstractKernel","page":"Home","title":"BaytesCore.AbstractKernel","text":"abstract type AbstractKernel\n\nAbstract super type for Algorithm Kernels.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.AbstractTune","page":"Home","title":"BaytesCore.AbstractTune","text":"abstract type AbstractTune\n\nAbstract super type for Tuning Algorithms.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.AcceptStatistic","page":"Home","title":"BaytesCore.AcceptStatistic","text":"struct AcceptStatistic{T<:AbstractFloat}\n\nStores in diagnostics.\n\nFields\n\nrate::AbstractFloat\nAcceptance rate\naccepted::Bool\nStep accepted or rejected\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.Accumulator","page":"Home","title":"BaytesCore.Accumulator","text":"mutable struct Accumulator\n\nMutable iterator struct that can be stored and updated in immutable structs. Contains cumulative and current value of input.\n\nFields\n\ncumulative::Float64\nCumulative value of all inputs.\ncurrent::Float64\nCurrent input value.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.ArrayConfig","page":"Home","title":"BaytesCore.ArrayConfig","text":"struct ArrayConfig{K, T<:BaytesCore.DataSorting}\n\nArray configuration struct.\n\nChecks if data is propagated row or column wise.\n\nFields\n\nsize::Tuple{Vararg{Int64, K}} where K\nDimension of data.\nsorted::BaytesCore.DataSorting\nBoolean if data is sorted by row\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.Batch","page":"Home","title":"BaytesCore.Batch","text":"struct Batch <: DataStructure\n\nDetermines whether only full data can be used.\n\nFields\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.ByCols","page":"Home","title":"BaytesCore.ByCols","text":"Data is sorted by columns.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.ByRows","page":"Home","title":"BaytesCore.ByRows","text":"Data is sorted by rows.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.ChainsTune","page":"Home","title":"BaytesCore.ChainsTune","text":"mutable struct ChainsTune\n\nHolds tuning information for number of chains in comparison to data.\n\nFields\n\ncoverage::Float64\nProposed coverage of number of chains/number of data points.\nthreshold::Float64\nThreshold for resampling, between 0.0 and 1.0.\nNchains::Int64\nNumber of chains.\nNdata::Int64\nNumber of data points.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.DataSorting","page":"Home","title":"BaytesCore.DataSorting","text":"Abstract super type for sorting data in different dimensions.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.DataStructure","page":"Home","title":"BaytesCore.DataStructure","text":"Abstract super type to define valid data structures.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.DataTune","page":"Home","title":"BaytesCore.DataTune","text":"struct DataTune{D<:DataStructure, C<:ArrayConfig, M}\n\nData tuning struct.\n\nContains information about data structure.\n\nFields\n\nstructure::DataStructure\nSubtype of DataStructure\nconfig::ArrayConfig\nData dimension configuration.\nmiss::Any\nTreatment of missing data.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.Expanding","page":"Home","title":"BaytesCore.Expanding","text":"struct Expanding <: DataStructure\n\nDetermines if data size for sampler is increasing over time.\n\nFields\n\nindex::Iterator\nmaximal visible index\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.Iterator","page":"Home","title":"BaytesCore.Iterator","text":"mutable struct Iterator\n\nMutable struct that can be stored and updated in immutable structs. Contains current iteration value.\n\nFields\n\ncurrent::Int64\nCurrent iteration number.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.JitterTune","page":"Home","title":"BaytesCore.JitterTune","text":"struct JitterTune\n\nContainer that determines if jittering has to be applied\n\nFields\n\nNsteps::Iterator\nNumber of jitttering steps performed while jittering\nthreshold::Float64\nJittering threshold for correlation of parameter.\nmin::Int64\nMinimum amount of jittering steps.\nmax::Int64\nMaximum amount of jittering steps.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.ParameterWeighting","page":"Home","title":"BaytesCore.ParameterWeighting","text":"abstract type ParameterWeighting\n\nSuper type for parameter weighting techniques.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.ParameterWeights","page":"Home","title":"BaytesCore.ParameterWeights","text":"struct ParameterWeights\n\nContainer for weights and normalized particles weights at current time step t.\n\nFields\n\nℓweights::Vector{Float64}\nUsed for log likelihood calculation.\nℓweightsₙ::Vector{Float64}\nexp(ℓweightsₙ) used for resampling particles and sampling trajectories ~ kept in log space for numerical stability.\nbuffer::Vector{Float64}\nA buffer vector with same size as ℓweights and ℓweightsₙ.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.PrintDefault","page":"Home","title":"BaytesCore.PrintDefault","text":"struct PrintDefault\n\nDefault arguments for printing summary statistics after sampling.\n\nFields\n\nNdigits::Int64\nNumber of Digits for rounding summary statistics.\nquantiles::Vector{Float64}\nQuantiles for summary statistics.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.ResampleTune","page":"Home","title":"BaytesCore.ResampleTune","text":"struct ResampleTune{R<:ResamplingMethod}\n\nStores information about resampling steps.\n\nFields\n\nmethod::ResamplingMethod\nMethod for resampling.\nupdate::Updater\nStores if last iteration was resampled.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.ResamplingMethod","page":"Home","title":"BaytesCore.ResamplingMethod","text":"abstract type ResamplingMethod\n\nSuper type for various particle resampling techniques.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.Rolling","page":"Home","title":"BaytesCore.Rolling","text":"struct Rolling <: DataStructure\n\nDetermines if data size for sampler is rolled forward over time.\n\nFields\n\nlength::Int64\nRolling window.\nindex::Iterator\nmaximal visible index\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.SubSampled","page":"Home","title":"BaytesCore.SubSampled","text":"struct SubSampled <: DataStructure\n\nDetermines whether data can be subsampled for inference.\n\nFields\n\nbuffer::Vector{Int64}\nBuffer index for subsampled indices.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.TemperDefault","page":"Home","title":"BaytesCore.TemperDefault","text":"struct TemperDefault{A<:UpdateBool, T<:(Union{AbstractVector{R}, R} where R<:AbstractFloat)}\n\nDefault arguments for tempering target function.\n\nFields\n\nadaption::UpdateBool\nChecks if temperature will be updated after new iterations\nval::Union{AbstractVector{R}, R} where R<:AbstractFloat\nInitial value for temperature if adaption is used.     Otherwise used to change shape of temperature until it reaches 1.0.     The smaller, the more linear the trajectory. The higher, the sooner 1.0 will be reached.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.TemperingParameter","page":"Home","title":"BaytesCore.TemperingParameter","text":"struct TemperingParameter{T<:AbstractFloat}\n\nHolds information about updating tempering parameter, parameter for basic logistic function\n\nFields\n\nL::AbstractFloat\nk::AbstractFloat\nx₀::AbstractFloat\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.TemperingTune","page":"Home","title":"BaytesCore.TemperingTune","text":"struct TemperingTune{A<:UpdateBool, T<:AbstractFloat}\n\nSummary struct for Tempering parameter.\n\nFields\n\nadaption::UpdateBool\nIf true, temperature will be adapted.\nval::ValueHolder{T} where T<:AbstractFloat\ncurrent temperature.\nparameter::TemperingParameter\nTuning parameter for temperature adjustment.\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.UpdateBool","page":"Home","title":"BaytesCore.UpdateBool","text":"abstract type UpdateBool\n\nAbstract super type if update has to be applied for given function.\n\nFields\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.Updater","page":"Home","title":"BaytesCore.Updater","text":"mutable struct Updater\n\nMutable struct to store update information that can be stored and updated in immutable structs. Contains boolean if updated is needed. Note that a UpdateBool field cannot be stored and updated as a concrete type here.\n\nFields\n\ncurrent::Bool\nBoolean of whether update has to be applied\n\n\n\n\n\n","category":"type"},{"location":"#BaytesCore.ValueHolder","page":"Home","title":"BaytesCore.ValueHolder","text":"mutable struct ValueHolder{T<:Real}\n\nMutable struct to hold a single scalar value that can be stored and updated in immutable structs.\n\nFields\n\ncurrent::Real\nScalar value\n\n\n\n\n\n","category":"type"},{"location":"#Base.split-Union{Tuple{TemperDefault{B, F}}, Tuple{F}, Tuple{B}} where {B<:UpdateBool, F<:(AbstractVector)}","page":"Home","title":"Base.split","text":"Split default.val temperatures into sepatre TemperDefault structs with scalar temperature.\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.Tuple_to_Namedtuple-Tuple{Tuple, Any}","page":"Home","title":"BaytesCore.Tuple_to_Namedtuple","text":"Convert Tuple tup to NamedTuple with all fields equal to val.\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.adapt","page":"Home","title":"BaytesCore.adapt","text":"adapt\n\nUpdate tuning container\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.adapt!","page":"Home","title":"BaytesCore.adapt!","text":"adapt!\n\nInplace version of adapt.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.adjust-Tuple{DataTune{<:Batch}, Any}","page":"Home","title":"BaytesCore.adjust","text":"adjust(tune, data)\n\n\nAdjust data with current datatune configuration.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.checktemperature-Tuple{TemperingParameter, Integer}","page":"Home","title":"BaytesCore.checktemperature","text":"checktemperature(param, iterations)\n\n\nHelper function to determine temperature shape given param variables.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.computeESS-Union{Tuple{Vector{T}}, Tuple{T}} where T<:AbstractFloat","page":"Home","title":"BaytesCore.computeESS","text":"computeESS(weightsₙ)\n\n\nCompute effectice sample size of particle filter via normalized log weights.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.draw!-Tuple{Random.AbstractRNG, ParameterWeights}","page":"Home","title":"BaytesCore.draw!","text":"draw!(_rng, weights)\n\n\nDraw proposal trajectory index.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.generate_showvalues","page":"Home","title":"BaytesCore.generate_showvalues","text":"generate_showvalues\n\nShow values of Algorihm diagnostics.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.get_iteration","page":"Home","title":"BaytesCore.get_iteration","text":"get_iteration\n\nGet current iteration of sampler combination.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.get_loglik","page":"Home","title":"BaytesCore.get_loglik","text":"get_loglik\n\nGet log likelihood of sampler combination.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.get_phase","page":"Home","title":"BaytesCore.get_phase","text":"get_phase\n\nGet phase tune struct of sampler combination.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.get_prediction","page":"Home","title":"BaytesCore.get_prediction","text":"get_prediction\n\nGet predictions of sampler combination.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.get_result","page":"Home","title":"BaytesCore.get_result","text":"get_result\n\nShow log density result.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.get_tagged","page":"Home","title":"BaytesCore.get_tagged","text":"get_tagged\n\nShow tagged parameter.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.grab-Tuple{Any, Any, Any}","page":"Home","title":"BaytesCore.grab","text":"grab(data, index, sorted)\n\n\nReturn allocation friendly index of array argument.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.infer","page":"Home","title":"BaytesCore.infer","text":"infer\n\nInfer output type from input\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.init","page":"Home","title":"BaytesCore.init","text":"init\n\nInitialize struct.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.init!","page":"Home","title":"BaytesCore.init!","text":"init!\n\nInplace version of init.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.init-Union{Tuple{F}, Tuple{T}, Tuple{Type{T}, UpdateFalse, TemperDefault{UpdateFalse, F}, TemperingParameter}} where {T<:AbstractFloat, F<:AbstractFloat}","page":"Home","title":"BaytesCore.init","text":"init(_, adaption, default, parameter)\n\n\nInitialize temperature.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.islarger-Union{Tuple{T}, Tuple{T, T}} where T<:Real","page":"Home","title":"BaytesCore.islarger","text":"islarger(x, threshold)\n\n\nCheck if x is larger than threshold, guaranteeing same type for arguments.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.jitter!-Union{Tuple{T}, Tuple{JitterTune, T}} where T<:AbstractFloat","page":"Home","title":"BaytesCore.jitter!","text":"jitter!(tune, ρ)\n\n\nCheck if we can stop jittering step based on correlation ρ.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.keyunion-Union{Tuple{Ty}, Tuple{Ky}, Tuple{Tx}, Tuple{Kx}, Tuple{NamedTuple{Kx, Tx}, NamedTuple{Ky, Ty}}} where {Kx, Tx, Ky, Ty}","page":"Home","title":"BaytesCore.keyunion","text":"Generate union of fields from 2 NamedTuples x and y.\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.logmeanexp-Union{Tuple{Vector{T}}, Tuple{T}} where T<:Real","page":"Home","title":"BaytesCore.logmeanexp","text":"logmeanexp(arr)\n\n\nNumerically stable version for log(mean(exp(vec))).\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.normalize!-Tuple{ParameterWeights}","page":"Home","title":"BaytesCore.normalize!","text":"normalize!(weights)\n\n\nInplace-Normalize parameter weights, accounting for ℓweightsₙ at previous iteration.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.propagate","page":"Home","title":"BaytesCore.propagate","text":"propagate\n\nPropagate algorithm one step forward.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.propagate!","page":"Home","title":"BaytesCore.propagate!","text":"propagate!\n\nInplace version of propagate.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.propose","page":"Home","title":"BaytesCore.propose","text":"propose\n\nPropose new parameter with given algorithm.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.propose!","page":"Home","title":"BaytesCore.propose!","text":"propose!\n\nInplace version of propose.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.randcat-Tuple{Random.AbstractRNG, AbstractVector{<:Real}}","page":"Home","title":"BaytesCore.randcat","text":"randcat(_rng, p)\n\n\nMore stable, faster version of rand(Categorical) if weights sum up to 1.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.resample!","page":"Home","title":"BaytesCore.resample!","text":"Resample particles, dispatched on ResamplingMethod subtypes.\n\nExamples\n\n\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.result!","page":"Home","title":"BaytesCore.result!","text":"result!\n\nSubstitute result with new result.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.results","page":"Home","title":"BaytesCore.results","text":"results\n\nShow results of input type.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.shuffle_backward!-Union{Tuple{I}, Tuple{P}, Tuple{AbstractMatrix{P}, AbstractArray{P}, AbstractMatrix{I}, AbstractVector{I}}} where {P, I<:Integer}","page":"Home","title":"BaytesCore.shuffle_backward!","text":"shuffle_backward!(val, buffer_val, ancestor, buffer_ancestor)\n\n\nSimilar to suffle, sort val elements at last column according to buffer indices, using ancestors as buffer. buffer indices will be different for each column, and will be adjusted accordingly.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.shuffle_forward!-Union{Tuple{I}, Tuple{P}, Tuple{AbstractMatrix{P}, AbstractArray{P}, AbstractMatrix{I}, AbstractVector{I}, Integer, Integer}} where {P, I<:Integer}","page":"Home","title":"BaytesCore.shuffle_forward!","text":"shuffle_forward!(val, buffer_val, ancestor, buffer_ancestor, lookback, iterₘₐₓ)\n\n\nSort val elements from iterₘₐₓ up until 'lookback' according to ancestor indices at iterₘₐₓ. ancestor at `iterₘₐₓ - lookback' will be adjusted accordingly.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.subset-Tuple{NamedTuple, NamedTuple}","page":"Home","title":"BaytesCore.subset","text":"Subset NamedTuple obj with keys of s without allocations.\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.subset-Tuple{NamedTuple, Tuple{Vararg{Symbol}}}","page":"Home","title":"BaytesCore.subset","text":"subset(nt, s)\n\n\nSubset nt with arguments s\n\nExamples\n\njulia> subset( (a = 1., b = 2., c = 3.), (:a, :b) )\n(a = 1., b = 2.)\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.to_NamedTuple-Tuple{Tuple, AbstractVector}","page":"Home","title":"BaytesCore.to_NamedTuple","text":"Convert Tuple tup to NamedTuple with fields equal to val.\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.to_NamedTuple_generated-Tuple{Any}","page":"Home","title":"BaytesCore.to_NamedTuple_generated","text":"Convert struct x to NamedTuple without additional allocations.\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.to_Tuple_generated-Tuple{Any, Vararg{Any}}","page":"Home","title":"BaytesCore.to_Tuple_generated","text":"Subset NamedTuple x given symbols sym without additional allocations.\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.to_Tuple_generated-Tuple{Any}","page":"Home","title":"BaytesCore.to_Tuple_generated","text":"Convert strcut x to tuple.\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.update","page":"Home","title":"BaytesCore.update","text":"update\n\nUpdate struct and return new type.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.update!","page":"Home","title":"BaytesCore.update!","text":"update!\n\nUpdate fields of existing struct.\n\n\n\n\n\n","category":"function"},{"location":"#BaytesCore.update!-Tuple{ParameterWeights}","page":"Home","title":"BaytesCore.update!","text":"update!(weights)\n\n\nSet weights back to equal.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.update!-Tuple{Random.AbstractRNG, DataTune, Batch}","page":"Home","title":"BaytesCore.update!","text":"update!(_rng, tune, structure)\n\n\nUpdate datetune struct based on datastructure.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.update-Union{Tuple{T}, Tuple{TemperingParameter{T}, Integer}} where T<:AbstractFloat","page":"Home","title":"BaytesCore.update","text":"update(param, index)\n\n\nCalculate new temperature based on current iteration.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#BaytesCore.weight!-Tuple{}","page":"Home","title":"BaytesCore.weight!","text":"weight!()\n\n\nWeight function that is dispatched on BaytesCore.ParameterWeighting types.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"},{"location":"#Random.shuffle!-Union{Tuple{I}, Tuple{P}, Tuple{AbstractMatrix{P}, AbstractArray{P}, AbstractVector{I}}} where {P, I<:Integer}","page":"Home","title":"Random.shuffle!","text":"shuffle!(val, buffer, ancestor)\n\n\nSort val elements at last column according to buffer indices, using ancestors as buffer. Resort all previous columns accordingly.\n\nExamples\n\n\n\n\n\n\n\n","category":"method"}]
}
