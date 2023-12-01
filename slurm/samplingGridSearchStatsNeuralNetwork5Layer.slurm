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
#SBATCH --time=0-00:30:00               # maximum job run time in days-hours:minutes:secconds

#SBATCH --array=1-16

#SBATCH --job-name=stats-neural-net-5-sampling-search              # job name
#SBATCH --output=log/%x-%A-%a.out         # standard output from job
#SBATCH --error=log/%x-%A-%a.err          # standard error from job
##
## Optional parameters - remove one leading hashtag to enable
##
## Run 'man sbatch' for more information on the options above.
## Below, enter commands needed to execute your workload

# randomly sleep between 0 and 90 seconds to avoid overloading the matlab license server
#sleep $(shuf -i 0-90 -n 1)

module load math/matlab/2023a

cd ../

matlab -batch "pathSetup; p.LayerSizes=[10,10,10,10,10]; evalSamplingGridRowFeatureMethod(@StatsNeuralNetwork,${SLURM_ARRAY_TASK_ID},UseParallel=true,ClassifierParams=p)"
