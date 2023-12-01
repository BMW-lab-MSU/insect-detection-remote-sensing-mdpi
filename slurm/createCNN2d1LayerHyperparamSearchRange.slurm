#!/bin/bash
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
## Basic parameters
##
#SBATCH --account=
#SBATCH --partition=
#SBATCH --cpus-per-task=1               # number of cores to allocate
#SBATCH --mem=2G                        # ammount of Memory allocated
#SBATCH --time=0-00:05:00               # maximum job run time in days-hours:minutes:secconds
#SBATCH --job-name=create-hyperparams              # job name
#SBATCH --output=log/%x-%j.out         # standard output from job
#SBATCH --error=log/%x-%j.err          # standard error from job


module load math/matlab/2023a

cd ../

matlab -batch "pathSetup; createCNN2d1LayerHyperparamSearchRange"
