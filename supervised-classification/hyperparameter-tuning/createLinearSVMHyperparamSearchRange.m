function createLinearSVMHyperparamSearchRange()

CLASSIFIER_NAME = "LinearSVM";

% Set up data paths
beehiveDataSetup;

% Create the optimizable variables that will be used by bayesopt
optimizableParams = [
    optimizableVariable("BoxConstraint",[1e-3,1e3],Transform="log"),...
    optimizableVariable("KernelScale",[1e-3,1e3],Transform="log")
];

save(trainingDataDir + filesep + CLASSIFIER_NAME ...
    + "HyperparameterSearchValues","optimizableParams","-v7.3");

end
