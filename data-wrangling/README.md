# Data wrangling
This folder contains code for preparing the data: creating labels, splitting into training/validation/testing sets, etc.

- `convertAllLabels`: converts all csv labels into mat files containing row and image label vectors.
- `createRowLabelVectors`: converts csv labels into row label vectors.
- `createImageLabelVectors`: converts csv labels into image label vectors.
- `combineData`: base function to combine data from multiple folders into one file.
- `combineDataForTrainingTesting`: combines all June data into a June file, and all July data into a July file.
- `splitData`: splits the preprocessed data files into training, validation, and testing sets.
- `prepareFeaturesAndLabelsForPython`: converts the training features and labels into a format that can be used in Python for computing mutual information.
