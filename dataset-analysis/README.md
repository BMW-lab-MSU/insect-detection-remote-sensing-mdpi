# Dataset analysis

This folder contains code for analyzing the dataset.

- `fundamentalFreqAnalysis`: computes the fundamental frequency of each bee in the dataset.
- `transitTime`: computes the transit time of each bee in the dataset.
- `computePRFStats`: computes the average PRF for each image in the dataset.
- `computeAvgImageDuration`: computes statistics for the image durations.
- `analyzeBeeLocations`: visualizes which range bins the bees are located in.
- `computeMutualInfo`: computes mutual information between the training features and labels.

Computing the mutual information is a two step process:
1. Prepare the data to be loaded by Python: [`prepareFeaturesAndLabelsForPython`](../data-wrangling/prepareFeaturesAndLabelsForPython.m)
2. Run `computeMutualInfo.py` from this directory:

    `python computeMutualInfo.py`

You may have to adjust the folder paths in `computeMutualInfo.py`.