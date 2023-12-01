#!/bin/bash

output=`sbatch combineData.slurm`
jobid=`echo "${output}" | cut -d' ' -f4`

output=`sbatch --dependency=afterok:"${jobid}" preprocess.slurm`
jobid=`echo "${output}" | cut -d' ' -f4`

output=`sbatch --dependency=afterok:"${jobid}" splitData.slurm`

