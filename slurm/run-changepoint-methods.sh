#!/bin/bash

methods=(\
    "gfpopRows"\
    "gfpopCols"\
    "gfpopBoth"\
    "matlabChptsRows"\
    "matlabChptsCols"\
    "matlabChptsBoth")

jobid_array=()

for method in "${methods[@]}"; do
    output=`sbatch "${method}".slurm`
    jobid_array+=(`echo "${output}" | cut -d' ' -f4`)
done

# Combine job ids into a string separated by colons.
# This will be used for the job dependency list.
printf -v job_ids "%s:" "${jobid_array[@]}"

# Remove the last colon
job_ids="${job_ids%?}"

sbatch --dependency=afterok:"${job_ids}" changepointAnalysis.slurm

