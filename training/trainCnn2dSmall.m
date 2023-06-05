if isempty(gcp('nocreate'))
    numGPUs = gpuDeviceCount("available");
    parpool(numGPUs, 'IdleTimeout', Inf);
end

%% Load relevant files
load([trainingDir filesep 'tuningCNN2dSmall']);            %"result"
load([trainingDir filesep 'trainingData']);

%% extract the optimal hyperparameter values
undersamplingRatio=result.UndersamplingRatio;
costRatio=result.CostRatio;

%% create hyperparameter structure

hyperparams.UndersamplingRatio = undersamplingRatio;
hyperparams.CostRatio=costRatio;    %used to calculate weight vector in cvobjfun.m
hyperparams.Cost=[1,costRatio];
hyperparams.Cost = hyperparams.Cost / mean(hyperparams.Cost);

%% Undersample the majority class
idxRemove = randomUndersample(...
    imageLabels(training(holdoutPartition)), 0, ...
    'UndersamplingRatio', undersamplingRatio, ...
    'Reproducible', true);

trainingFeatures(idxRemove) = [];
trainingData(idxRemove) = [];
trainingLabels(idxRemove) = [];


%% train the model
model = fitCnn2dSmall(trainingData, trainingLabels, hyperparams);

mkdir([trainingDir filesep 'models']);
save([trainingDir filesep 'models' filesep 'Cnn2dSmall.mat'] ,"model")
