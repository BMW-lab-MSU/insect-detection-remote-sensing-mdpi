function createCNN1d1LayerHyperparamSearchRange()

% SPDX-License-Identifier: BSD-3-Clause

CLASSIFIER_NAME = "CNN1d1Layer";

% Set up data paths
beehiveDataSetup;

% Create the optimizable variables that will be used by bayesopt
optimizableParams = [
    optimizableVariable("FilterSize1",[2,64],Type="integer"),...
    optimizableVariable("NFilters1",[16,32],Type="integer"),...
    optimizableVariable("FalseNegativeCost",[1 10],Type="integer")
];

save(trainingDataDir + filesep + CLASSIFIER_NAME ...
    + "HyperparameterSearchValues","optimizableParams","-v7.3");

end
