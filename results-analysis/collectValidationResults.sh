#!/bin/bash

# Combine the validation results from each model into one file.
# Viewing the results in one file is easier.

OUT_FILE="validation-results.txt"
RESULTS_DIR="../../results/training/hyperparameter-tuning/"


cd "${RESULTS_DIR}"

# clear the validation results file
echo -n "" > "${OUT_FILE}"

for results_file in *Results.txt; do
    classifier_name=${results_file%%Results.txt}

    echo "${classifier_name}" >> "${OUT_FILE}"
    echo "------------------------------" >> "${OUT_FILE}"

    cat "${results_file}" >> "${OUT_FILE}"

    echo -en "\n\n" >> "${OUT_FILE}"
done
