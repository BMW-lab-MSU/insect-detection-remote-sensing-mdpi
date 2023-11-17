# insect-detection-remote-sensing-mdpi

This software is associated with the publication titled "Comparison of Supervised Learning and Changepoint Detection for Insect Detection in Lidar Data" by authors T. C. Vannoy, N. B. Sweeney, J. A. Shaw, and B. M. Whitaker." by authors T. C. Vannoy, N. B. Sweeney, J. A. Shaw, and B. M. Whitaker.

The associated dataset can be found at https://doi.org/10.5281/zenodo.10055763.

# Data paths
You can specify the locations of the data and results folders in the `beehiveDataSetup.m` script. By default, the scripts uses the following relative path setup, where `code` is a folder containing this repository:
```
├── code
├── data
│   ├── combined
│   ├── preprocessed
│   ├── raw
│   │   ├── 2022-06-23
│   │   ├── 2022-06-24
│   │   ├── 2022-07-28
│   │   ├── 2022-07-29
│   ├── testing
│   ├── training
│   └── validation
└── results
    ├── changepoint-results
    │   └── runtimes
    ├── testing
    └── training
        ├── classifiers
        ├── data-sampling
        ├── default-params
        └── hyperparameter-tuning
```

# Running the code

In general, you need to call `pathSetup.m` first before running anything, as that script adds all the folders in this repo to your MATLAB path. Additionally, if you use the default relative data path setup described above, you must run all of your code from the root of this repository, not the subfolders; if you specify full paths in `beehiveDataSetup.m`, then you can run the code from anywhere.

## Data preparation

0. (optional) Convert the csv label files into .mat files using `convertAllLabels.m`; this has already been done in the archived dataset.
1. Combine the individual raw data files into larger groups that can then be split into training and testing sets; this is done with `combineDataForTrainingTesting.m`
2. Preprocess the data using `preprocess.m`
3. Split the preprocessed data into the training, validation, and testing sets. `spiltData.m`

## Supervised learning

### Feature extraction
Before training any of the feature-based algorithms, we need to precompute the features:

- training data: `precomputeTrainingFeatures.m`
- validation data: `precomputeValidationFeatures.m`
- testing data: `precomputeTestingFeatures.m`

### Training
#### Data sampling parameter tuning
First, we need to create the grid search parameters using `createDataSamplingGrid.m`. Once that is done, we can perform the grid search.

For the feature-based methods, call the `evalSamplingGridRowFeatureMethod` function with the grid search index, e.g.
```matlab
evalSamplingGridRowFeatureMethod(@AdaBoost,1,UseParallel=true,UseGPU=true)
```

For the deep learning methods, call the `evalSamplingGridRowDataMethod` function with the grid search index, e.g.
```matlab
evalSamplingGridRowDataMethod(@CNN1d,1,UseParallel=true,UseGPU=true)
```

This grid search was designed to run in parallel on a computing cluster, specifically using slurm job arrays. See the `samplingGridSearch*.slurm` scripts for full details of the function calls for each of the classifiers. In particular, for the neural networks that had more than one hidden layer, we have to pass in the parameters (e.g., layer sizes) into the `evalSamplingGrid*` functions.


Once the grid search for an algorithm is done, run the `selectBestSamplingParams` function to save the sampling parameters that resulted in the best MCC value, e.g.:
```matlab
selectBestSamplingParams("AdaBoost")
```


#### Model hyperparameter tuning

First, we need to create mat files that contain the model's hyperparameter search values.

### Testing

## Changepoint detection

