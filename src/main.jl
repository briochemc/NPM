
# Model setup
include("metaparameters.jl")  # grd, etc.
include("parameters.jl")
include("model_functions.jl") # functions

# Optimization
include("optim_setup.jl")
include("optimize.jl")

# save
data_path = joinpath(@__DIR__, "..", "data")
BSON.@save joinpath(data_path, "optimized_N.bson") s_optimized p_optimized

# save for plots
DIN, PON = unpack_tracers(s_optimized,grd)
uptake_optimized = uptake(DIN,p_optimized)
remin_optimized = remin(PON,p_optimized)
fixation_optimized = fixation(DIN,p_optimized)
denit_optimized = denit(DIN,p_optimized)

BSON.@save joinpath(data_path, "optimized_N_4plt.bson") DIN PON uptake_optimized remin_optimized fixation_optimized denit_optimized 
