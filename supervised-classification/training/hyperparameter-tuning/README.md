# Hyperparameter tuning

This folder contains all the hyperparameter tuning functions. Bayesian optimization (`bayesopt`) was used to tune the hyperparameters.

All of the `create*HyperparamSearchRange` functions define the hyperparameters and their search ranges for each classifier. These files save the parameters as a mat file, which is loaded later during hyperparameter tuning.

There are three different hyperparameter tuning functions, one for each of the algorithm types:
- feature engineering methods: `tuneHyperparamsRowFeatureMethod`
- 1D CNNs: `tuneHyperparamsRowDataMethod`
- 2D CNNs: `tuneHyperparamsImageMethod`

[`validationObjFcn`](../validationObjFcn.m) is the objective function that is passed to `bayesopt`.
