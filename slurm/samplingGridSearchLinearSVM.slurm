#!/bin/bash
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
## Basic parameters
##
#SBATCH --account=
#SBATCH --partition=

#SBATCH -n 32
#SBATCH --mem 60G
#SBATCH --exclusive

#SBATCH --time=0-04:00:00               # maximum job run time in days-hours:minutes:secconds

#SBATCH --array=1-16

#SBATCH --job-name=linear-svm-sampling-search             # job name
#SBATCH --output=log/%x-%A-%a.out         # standard output from job
#SBATCH --error=log/%x-%A-%a.err          # standard error from job

module load math/matlab/2023a

cd ../

matlab -batch "pathSetup; evalSamplingGridRowFeatureMethod(@SVM,${SLURM_ARRAY_TASK_ID},UseParallel=true)"
