function createStatsNeuralNetwork5LayerHyperparamSearchRange()

CLASSIFIER_NAME = "StatsNeuralNetwork5Layer";

% Set up data paths
beehiveDataSetup;

% Find the number of observations in the training dataset so we can set the search
% range for lambda. We can look at the number of observations in the row labels rather
% than loading the actual data, as this will be faster.
load(trainingDataDir + filesep + "trainingData","trainingRowLabels");
nObservations = numel(vertcat(trainingRowLabels{:}));

% Create the optimizable variables that will be used by bayesopt
optimizableParams = [
    optimizableVariable("LayerSize1",[5,100],Type="integer",Transform="log"),...
    optimizableVariable("LayerSize2",[5,100],Type="integer",Transform="log"),...
    optimizableVariable("LayerSize3",[5,100],Type="integer",Transform="log"),...
    optimizableVariable("LayerSize4",[5,100],Type="integer",Transform="log"),...
    optimizableVariable("LayerSize5",[5,100],Type="integer",Transform="log"),...
    optimizableVariable("Lambda",1/nObservations * [1e-5,1],Transform="log"),...
    optimizableVariable("Activations", ["relu", "tanh", "sigmoid"]),...
    optimizableVariable("FalseNegativeCost",[1 10],Type="integer")
];

save(trainingDataDir + filesep + CLASSIFIER_NAME ...
    + "HyperparameterSearchValues","optimizableParams","-v7.3");

end
