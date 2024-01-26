#!/bin/bash

classifiers=(\
    "CNN2d1Layer"\
    "CNN2d3Layer"\
    "CNN2d5Layer"\
    "CNN2d7Layer")

for classifier in "${classifiers[@]}"; do
    output=`sbatch trainDefault"${classifier}".slurm`
    jobid1=`echo "${output}" | cut -d' ' -f4`

    output=`sbatch create"${classifier}"HyperparamSearchRange.slurm`
    jobid2=`echo "${output}" | cut -d' ' -f4`

    output=`sbatch --dependency=afterok:"${jobid1}:${jobid2}" tuneHyperparams"${classifier}".slurm`
    jobid=`echo "${output}" | cut -d' ' -f4`

    output=`sbatch --dependency=afterok:"${jobid}" trainFinal"${classifier}".slurm`
    jobid=`echo "${output}" | cut -d' ' -f4`

    sbatch --dependency=afterok:"${jobid}" "test${classifier}.slurm"
done

