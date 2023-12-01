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
#SBATCH --job-name=select-sampling-cnn1d7layer              # job name
#SBATCH --output=log/%x-%j.out         # standard output from job
#SBATCH --error=log/%x-%j.err          # standard error from job
##
## Optional parameters - remove one leading hashtag to enable
##
##SBATCH --nodes=1                      # number of nodes to allocate for multinode job
##SBATCH --ntasks-per-node=1            # number of descrete tasks to allocate for MPI job
##SBATCH --array=1-3                    # number of jobs in array for job array
##SBATCH --gpus-per-task=1              # number of GPUs to allocate for GPU job
##SBATCH --gres=gpu:a40:2
## Run 'man sbatch' for more information on the options above.
## Below, enter commands needed to execute your workload


module load math/matlab/2023a

cd ../

matlab -batch "pathSetup; selectBestSamplingParams(\"CNN1d7Layer\")"
