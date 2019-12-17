#!/bin/bash

#SBATCH --job-name=optimize_coupled_NP_model_v3
#SBATCH --output=cluster_output/optimize_coupled_NP_model_v3.out
#SBATCH --error=cluster_output/optimize_coupled_NP_model_v3.err
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --mem=32GB

# Load the julia module
export PATH=~/Applications/julia-1.3.0/bin:$PATH
export LD_LIBRARY_PATH=~/Applications/julia-1.3.0/lib

# Cd to the root folder on USC HPC cluster
cd /home/geovault-06/pasquier/Projects/NPM

# Run it!
ulia src/coupled_NP_model_v3/cluster_run.jl