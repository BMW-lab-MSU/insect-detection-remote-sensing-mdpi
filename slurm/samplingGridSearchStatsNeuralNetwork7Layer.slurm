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
#SBATCH --mem=60G                        # ammount of Memory allocated
#SBATCH --time=0-02:00:00               # maximum job run time in days-hours:minutes:secconds

#SBATCH --exclusive

#SBATCH --array=1-16

#SBATCH --job-name=stats-neural-net-7-sampling-search              # job name
#SBATCH --output=log/%x-%A-%a.out         # standard output from job
#SBATCH --error=log/%x-%A-%a.err          # standard error from job

module load math/matlab/2023a

cd ../

matlab -batch "pathSetup; p.LayerSizes=[10,10,10,10,10,10,10]; evalSamplingGridRowFeatureMethod(@StatsNeuralNetwork,${SLURM_ARRAY_TASK_ID},UseParallel=true,ClassifierParams=p)"
