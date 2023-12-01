#!/bin/bash
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
## Basic parameters
##
#SBATCH --account=
#SBATCH --partition=

#SBATCH --cpus-per-task=16               # number of cores to allocate
#SBATCH --mem=64G                        # ammount of Memory allocated
#SBATCH --time=0-04:00:00               # maximum job run time in days-hours:minutes:secconds

#SBATCH --gres=gpu:1


#SBATCH --job-name=cnn1d1layer-testing
#SBATCH --output=log/%x-%j.out         # standard output from job
#SBATCH --error=log/%x-%j.err          # standard error from job

module load cuDNN/8.7.0.84-CUDA-11.8.0

module load math/matlab/2023a

cd ../

matlab -batch "pathSetup; testRowDataMethod(\"CNN1d1Layer\")" 

