# instantiate environment
using Pkg
Pkg.activate(".")
Pkg.instantiate()
Pkg.status()

# Ensure that the DataDeps download work remotely
ENV["DATADEPS_ALWAYS_ACCEPT"] = true

include("main.jl")


