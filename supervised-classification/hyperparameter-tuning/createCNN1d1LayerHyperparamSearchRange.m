function createCNN1d1LayerHyperparamSearchRange()

CLASSIFIER_NAME = "CNN1d1Layer";

% Set up data paths
beehiveDataSetup;

% Create the optimizable variables that will be used by bayesopt
optimizableParams = [
    optimizableVariable("FilterSize1",[2,128],Type="integer"),...
    optimizableVariable("NFilters1",[2,128],Type="integer"),...
    optimizableVariable("FalseNegativeCost",[1 10],Type="integer")
];

save(trainingDataDir + filesep + CLASSIFIER_NAME ...
    + "HyperparameterSearchValues","optimizableParams","-v7.3");

end
