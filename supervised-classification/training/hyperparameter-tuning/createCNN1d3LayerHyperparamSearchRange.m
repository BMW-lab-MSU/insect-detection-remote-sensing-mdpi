function createCNN1d3LayerHyperparamSearchRange()

% SPDX-License-Identifier: BSD-3-Clause

CLASSIFIER_NAME = "CNN1d3Layer";

% Set up data paths
beehiveDataSetup;

% Create the optimizable variables that will be used by bayesopt
optimizableParams = [
    optimizableVariable("FilterSize1",[2,64],Type="integer"),...
    optimizableVariable("FilterSize2",[2,64],Type="integer"),...
    optimizableVariable("FilterSize3",[2,32],Type="integer"),...
    optimizableVariable("NFilters1",[8,32],Type="integer"),...
    optimizableVariable("NFilters2",[8,32],Type="integer"),...
    optimizableVariable("NFilters3",[8,32],Type="integer"),...
    optimizableVariable("FalseNegativeCost",[1 10],Type="integer")
];

save(trainingDataDir + filesep + CLASSIFIER_NAME ...
    + "HyperparameterSearchValues","optimizableParams","-v7.3");

end
