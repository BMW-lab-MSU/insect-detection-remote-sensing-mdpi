#!/bin/bash
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
## Basic parameters
##
#SBATCH --account=
#SBATCH --partition=

#SBATCH --cpus-per-task=32               # number of cores to allocate
#SBATCH --mem=64G                        # ammount of Memory allocated
#SBATCH --time=0-01:00:00               # maximum job run time in days-hours:minutes:secconds

#SBATCH --job-name=nn1layer-training
#SBATCH --output=log/%x-%A-%a.out         # standard output from job
#SBATCH --error=log/%x-%A-%a.err          # standard error from job

module load math/matlab/2023a

cd ../

matlab -batch "pathSetup; trainRowFeatureMethod(\"StatsNeuralNetwork1Layer\",@StatsNeuralNetwork,UseParallel=true)" 

