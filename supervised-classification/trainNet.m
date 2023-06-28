if isempty(gcp('nocreate'))
    parpool('IdleTimeout', Inf);
end

%% Load relevant files
load([trainingDir filesep 'augCostTuningNet.mat']);
load([trainingDir filesep 'trainingData']);

%% extract the optimal hyperparameter values
undersamplingRatio=result.UndersamplingRatio;
costRatio=result.CostRatio;
nAugment=round(result.nAugment);

%%  create hyperparameter structure
hyperparams.CostRatio=costRatio;
hyperparams.Standardize=true;
hyperparams.Verbose=0;
hyperparams.LayerSizes=[100];
hyperparams.Standardize=true;

%% Undersample the majority class
idxRemove = randomUndersample(...
    imageLabels(training(holdoutPartition)), 0, ...
    'UndersamplingRatio', undersamplingRatio, ...
    'Reproducible', true);

trainingFeatures(idxRemove) = [];
trainingData(idxRemove) = [];
trainingLabels(idxRemove) = [];

%% Un-nest data/labels
data = vertcat(trainingData{:});
features = vertcat(trainingFeatures{:});
labels = vertcat(trainingLabels{:});

%% Create synthetic features
[synthFeatures, synthLabels] = createSyntheticFeatures(data, ...
    labels, nAugment, 'UseParallel', true);

features = vertcat(features, synthFeatures);
labels = vertcat(labels, synthLabels);
clear('synthFeatures', 'synthLabels');

%% train the model
model = fitNet(features, labels, hyperparams);

mkdir([trainingDir filesep 'models']);
save([trainingDir filesep 'models' filesep 'NNet.mat'] ,"model")

