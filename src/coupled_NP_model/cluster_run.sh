#!/bin/bash

#SBATCH --job-name=optimize_coupled_NP_model
#SBATCH --output=cluster_output/optimize_coupled_NP_model.out
#SBATCH --error=cluster_output/optimize_coupled_NP_model.err
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --mem=32GB

# Load the julia module

# Cd to the root folder on USC HPC cluster
cd /home/geovault-06/pasquier/Projects/NPM

# Set DataDeps environment variable to download without asking
DATADEPS_ALWAYS_ACCEPT = true

# Run it!
julia src/coupled_NP_model/cluster_run.jl
