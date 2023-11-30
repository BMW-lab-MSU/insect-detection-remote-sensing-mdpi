function createLinearSVMHyperparamSearchRange()

% SPDX-License-Identifier: BSD-3-Clause

CLASSIFIER_NAME = "LinearSVM";

% Set up data paths
beehiveDataSetup;

% Create the optimizable variables that will be used by bayesopt
optimizableParams = [
    optimizableVariable("BoxConstraint",[1e-3,1e3],Transform="log"),...
    optimizableVariable("KernelScale",[1e-3,1e3],Transform="log"),...
    optimizableVariable("FalseNegativeCost", [1 10],Type="integer"),...
];

save(trainingDataDir + filesep + CLASSIFIER_NAME ...
    + "HyperparameterSearchValues","optimizableParams","-v7.3");

end
