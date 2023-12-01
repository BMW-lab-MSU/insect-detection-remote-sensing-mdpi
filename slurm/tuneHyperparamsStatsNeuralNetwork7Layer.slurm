#!/bin/bash
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
## Basic parameters
##
#SBATCH --account=
#SBATCH --partition=

#SBATCH --cpus-per-task=64               # number of cores to allocate
#SBATCH --mem=128G                        # ammount of Memory allocated
#SBATCH --time=0-24:00:00               # maximum job run time in days-hours:minutes:secconds


#SBATCH --job-name=nn7layer-hyperparam-tuning              # job name
#SBATCH --output=log/%x-%A-%a.out         # standard output from job
#SBATCH --error=log/%x-%A-%a.err          # standard error from job

module load math/matlab/2023a

cd ../

matlab -batch "pathSetup; tuneHyperparamsRowFeatureMethod(\"StatsNeuralNetwork7Layer\",@StatsNeuralNetwork,UseParallel=true)" 
