# Code for tuning undersampling and oversampling

This folder contains the code for tuning the undersampling and oversampling factors for the row-based methods. 

This tuning is a grid search over various undersampling and oversampling ratios. The grid search was designed to be run on a computing cluster using slurm job arrays; consequently, only 1 point in the grid is evaluated by the main functions:
- `evalSamplingGridRowFeatureMethod` for the feature-based methods
- `evalSamplingGridRowDataMethod` for the data-based methods (1D CNN)

## Function descriptions:
- `createDataSamplingGrid`: creates and saves the data structure for the grid search.
- `evalSamplingGridRow{Feature,Data}Method`: performs training and validation for 1 grid point.
- `rowDataSampling`: performs the undersampling and oversampling.
- `writeGridSearchResultsToTxtFile`: writes results to a text file for easier viewing
- `selectBestSamplingParams`: determines which grid point had the highest validtion score and saves those parameters
