function createBoostedTreesHyperparamSearchRange()


% Set up data paths
beehiveDataSetup;

% Create the optimizable variables that will be used by bayesopt
optimizableParams = [
    optimizableVariable("FalseNegativeCost",[1 10],Type="integer"),...
    optimizableVariable('NumLearningCycles',[10, 500], 'Type', 'integer', 'Transform','log'),...
    optimizableVariable('LearnRate',[1e-3, 1], 'Transform','log'),...
    optimizableVariable('MinLeafSize',[1 1e4],'Transform','log', 'Type', 'integer'),...
];

% RUSBoost and AdaBoost both have the same hyperparameters, so we use
% this function to save the same optimizable variables for both
save(trainingDataDir + filesep + "RUSBoost" ...
    + "HyperparameterSearchValues","optimizableParams","-v7.3");

save(trainingDataDir + filesep + "AdaBoost" ...
    + "HyperparameterSearchValues","optimizableParams","-v7.3");

end
