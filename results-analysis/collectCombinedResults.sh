#!/bin/bash

# After running combineRunResults.m, this script can be used to combine the
# results from each classifier into one file for ease of viewing.

OG_DIR=${PWD}

TESTING_FILE="testing-results.txt"
TESTING_DIR="../../combined-results/testing/"

cd "${TESTING_DIR}"

# clear the testing resultsresutls file
echo -n "" > "${TESTING_FILE}"

for results_file in *Results.txt; do
    classifier_name=${results_file%%Results.txt}

    echo "${classifier_name}" >> "${TESTING_FILE}"
    echo "------------------------------" >> "${TESTING_FILE}"

    cat "${results_file}" >> "${TESTING_FILE}"

    echo -en "\n\n" >> "${TESTING_FILE}"
done

cd "${OG_DIR}"

VALIDATION_FILE="validation-results.txt"
VALIDATION_DIR="../../combined-results/validation/"

cd "${VALIDATION_DIR}"

# clear the testing resultsresutls file
echo -n "" > "${VALIDATION_FILE}"

for results_file in *Results.txt; do
    classifier_name=${results_file%%Results.txt}

    echo "${classifier_name}" >> "${VALIDATION_FILE}"
    echo "------------------------------" >> "${VALIDATION_FILE}"

    cat "${results_file}" >> "${VALIDATION_FILE}"

    echo -en "\n\n" >> "${VALIDATION_FILE}"
done
