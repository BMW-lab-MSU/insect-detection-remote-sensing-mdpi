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
#SBATCH --time=0-01:00:00               # maximum job run time in days-hours:minutes:secconds

#SBATCH --gres=gpu:1


#SBATCH --job-name=cnn2d3layer-testing
#SBATCH --output=log/%x-%j.out         # standard output from job
#SBATCH --error=log/%x-%j.err          # standard error from job

module load cuDNN/8.7.0.84-CUDA-11.8.0
#module load cuDNN/8.6.0.163-CUDA-11.8.0 
#module load cuDNN/8.0.4.30-CUDA-11.1.1

module load math/matlab/2022a

hostname

cd ../

matlab -batch "pathSetup; testImageMethod(\"CNN2d3Layer\")" 

