#!/bin/bash

classifiers=(\
    "AdaBoost"\
    "RUSBoost"\
    "CNN1d1Layer"\
    "CNN1d3Layer"\
    "CNN1d5Layer"\
    "CNN1d7Layer"\
    "LinearSVM"\
    "StatsNeuralNetwork1Layer"\
    "StatsNeuralNetwork3Layer"\
    "StatsNeuralNetwork5Layer"\
    "StatsNeuralNetwork7Layer")

output=`sbatch createDataSamplingGrid.slurm`
jobid_grid=`echo "${output}" | cut -d' ' -f4`

for classifier in "${classifiers[@]}"; do
    output=`sbatch --dependency=afterok:${jobid_grid} samplingGridSearch"${classifier}".slurm`
    jobid=`echo "${output}" | cut -d' ' -f4`


    if [ "${classifier}" == "AdaBoost" ] || [ "${classifier}" == "RUSBoost" ]; then
        output=`sbatch createBoostedTreesHyperparamSearchRange.slurm`
        jobid2=`echo "${output}" | cut -d' ' -f4`
    else
        output=`sbatch create"${classifier}"HyperparamSearchRange.slurm`
        jobid2=`echo "${output}" | cut -d' ' -f4`
    fi

    output=`sbatch --dependency=afterok:"${jobid}" selectBestSamplingParams"${classifier}".slurm`
    jobid1=`echo "${output}" | cut -d' ' -f4`

    output=`sbatch --dependency=afterok:"${jobid1}:${jobid2}" tuneHyperparams"${classifier}".slurm`
    jobid=`echo "${output}" | cut -d' ' -f4`

    output=`sbatch --dependency=afterok:"${jobid}" trainFinal"${classifier}".slurm`
    jobid=`echo "${output}" | cut -d' ' -f4`

    sbatch --dependency=afterok:"${jobid}" "test${classifier}.slurm"
done

