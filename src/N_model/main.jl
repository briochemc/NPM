
# paths
splitPWD = splitpath(@__DIR__) # current directory split
isrc = findfirst(isequal("src"), splitPWD)
model_name = splitPWD[isrc+1]
project_root_path = joinpath(splitPWD[1:isrc-1]...)
data_path = joinpath(project_root_path, "data", model_name)

# Model setup
include("metaparameters.jl")  # grd, etc.
include("parameters.jl")
#include("model_functions.jl") # functions
#
## save initial solution
#s = solve(prob, CTKAlg(), preprint="1st solve ").u
#BSON.@save joinpath(data_path, "initial_solution.bson") s p
#
## Optimization
#include("optim_setup.jl")
#include("optimize.jl")
#
## save optimized solution
#BSON.@save joinpath(data_path, "optimized_N.bson") s_optimized p_optimized
#BSON.@save joinpath(data_path, "optimized_solution.bson") s_optimized p_optimized
#
## save fields for plots
#DIP, POP, DIN, PON = unpack_tracers(s_optimized,grd)
#uptake_P_optimized = uptake_P(DIP,DIN,p_optimized)
#uptake_N_optimized = uptake_N(DIP,DIN,p_optimized)
#remin_P_optimized = remin_P(POP,p_optimized)
#remin_N_optimized = remin_N(PON,p_optimized)
#fixation_optimized = fixation(DIN,p_optimized)
#denit_optimized = denit(DIN,p_optimized)
#BSON.@save joinpath(data_path, "optimized_N_4plt.bson") DIP POP DIN PON uptake_P_optimized uptake_N_optimized remin_P_optimized remin_N_optimized fixation_optimized denit_optimized
