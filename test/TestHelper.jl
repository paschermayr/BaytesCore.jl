############################################################################################
# Constants
"RNG for sampling based solutions"
const _RNG = Random.MersenneTwister(1)   # shorthand
Random.seed!(_RNG, 1)

"Tolerance for stochastic solutions"
const _TOL = 1.0e-6

"Number of samples"
N = 10^3

"Initial number of data points for DataTune"
N_initial = Int64(N / 4)

############################################################################################
# Assign data configuration in various dimensions
data_uv = zeros(N)
data_mv = zeros(Int64(N / 2), 2)
data_mv2 = zeros(2, Int64(N / 2))
