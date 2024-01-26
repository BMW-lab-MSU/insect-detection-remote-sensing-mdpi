# Feature extraction

## Feature extraction functions
The main entry point for extracting all features in `extractFeatures`. In general, this is the only function you need to call.

See the documentation in the functions for more details.

### Unit tests
Unit tests are located in the `test` directory. You can run all the tests by running `runtests` in MATLAB while in the `test` directory. You must run `pathSetup` first because some tests use the `bandpassFilter` function.

For more information on running class-based unit tests, see [Mathwork's documentation](https://www.mathworks.com/help/matlab/class-based-unit-tests.html).

## Precomputing features on the dataset
Features are computed for the entire training, validation, and training sets using `precomputeTrainingFeatures`, `precomputeValidationFeatures`, and `precomputeTestingFeatures`, respectively. Computing the features in batch is much faster than doing it every time in other functions later on.