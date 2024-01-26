# Library functions
This folder contains library functions that are used elsewhere.

- `analyzeConfusion`: compute binary classification performance metrics given a confusion matrix.
- `imageConfusion`: compute image-based results from row-based labels
- `averagePRF`: compute the average pulse repetition frequency
- `formatGridSearchParams`: given a struct of parameter ranges, create a table that can be used for a single-for-loop grid search.
- `mergeStructs`: merge structs together into one.

See each function's documentation for more information.

## Unit tests
Unit tests for `mergeStructs` and `formatGridSearchParams` are in the `test` folder. You can run all the tests by running `runtests` in the `test` folder.