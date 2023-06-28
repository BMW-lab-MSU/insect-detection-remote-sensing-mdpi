if isempty(gcp('nocreate'))
    parpool('IdleTimeout', Inf);
end

%% Load relevant files
load([trainingDir filesep 'augCostTuningRUS']);            %"result"
load([trainingDir filesep 'trainingData']);

%% extract the optimal hyperparameter values
undersamplingRatio=result.UndersamplingRatio;
costRatio=result.CostRatio;
nAugment=round(result.nAugment);

%% create hyperparameter structure
hyperparams=struct();
hyperparams.ScoreTransform='doublelogit';
hyperparams.Cost=[0,1;costRatio,0];
hyperparams.ClassNames=logical([0,1]);
hyperparams.SplitCriterion='gdi';
hyperparams.LearnRate=0.1;

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
model = fitRUSBoost(features, labels, hyperparams);

mkdir([trainingDir filesep 'models']);
save([trainingDir filesep 'models' filesep 'RUSBoost.mat'] ,"model")
