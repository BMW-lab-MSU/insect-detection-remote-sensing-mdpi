function createCNN1d7LayerHyperparamSearchRange()

CLASSIFIER_NAME = "CNN1d7Layer";

% Set up data paths
beehiveDataSetup;

% Create the optimizable variables that will be used by bayesopt
optimizableParams = [
    optimizableVariable("FilterSize1",[2,64],Type="integer"),...
    optimizableVariable("FilterSize2",[2,64],Type="integer"),...
    optimizableVariable("FilterSize3",[2,32],Type="integer"),...
    optimizableVariable("FilterSize4",[2,16],Type="integer"),...
    optimizableVariable("FilterSize5",[2,8],Type="integer"),...
    optimizableVariable("FilterSize6",[2,8],Type="integer"),...
    optimizableVariable("FilterSize7",[2,4],Type="integer"),...
    optimizableVariable("NFilters1",[16,32],Type="integer"),...
    optimizableVariable("NFilters2",[16,32],Type="integer"),...
    optimizableVariable("NFilters3",[16,32],Type="integer"),...
    optimizableVariable("NFilters4",[16,32],Type="integer"),...
    optimizableVariable("NFilters5",[16,32],Type="integer"),...
    optimizableVariable("NFilters6",[16,32],Type="integer"),...
    optimizableVariable("NFilters7",[16,32],Type="integer"),...
    optimizableVariable("FalseNegativeCost",[1 10],Type="integer")
];

save(trainingDataDir + filesep + CLASSIFIER_NAME ...
    + "HyperparameterSearchValues","optimizableParams","-v7.3");

end