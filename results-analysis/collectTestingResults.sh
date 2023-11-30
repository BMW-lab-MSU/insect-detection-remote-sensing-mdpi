#!/bin/bash

# Combine all the testing results from each model into one file.
# Viewing the results in one file is easier.

OUT_FILE="testing-results.txt"
RESULTS_DIR="../../results/testing/"

cd "${RESULTS_DIR}"

# clear the testing resultsresutls file
echo -n "" > "${OUT_FILE}"

for results_file in *Results.txt; do
    classifier_name=${results_file%%Results.txt}

    echo "${classifier_name}" >> "${OUT_FILE}"
    echo "------------------------------" >> "${OUT_FILE}"

    cat "${results_file}" >> "${OUT_FILE}"

    echo -en "\n\n" >> "${OUT_FILE}"
done
