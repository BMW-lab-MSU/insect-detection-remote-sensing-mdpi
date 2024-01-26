# Results analysis
This folder contains code used to format and analyze the results.

- `analyzeConfidenceRatingEffects`: analyzes the effects of label confidence on recall. Used to create Figure 13.
- `analyzeLocationInvariance`: this function was not used in the paper; it does preliminary analysis to see if the location of bees in the image affected classification results for the 2D CNNs.
- ` combineRunResults`: combines results from different runs and computes statistics. Some of the algorithms are not deterministic, so this script computes statistics to get a better idea of the methods' performance across multiple runs.

## Collecting results into one file
Each method has an associated text file that contains its classification results. It is often easier to have the results from all methods in one file. The `collect*Results.sh` bash scripts combine the results into one text file.