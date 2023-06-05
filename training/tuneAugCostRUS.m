% SPDX-License-Identifier: BSD-3-Clause
%% Setup
rng(0, 'twister');

if isempty(gcp('nocreate'))
   parpool('IdleTimeout', Inf);
end

%% Load data
load([trainingDir filesep 'trainingData.mat']);

%% Tune cost and aug ratios

% Create the grid
costRatios = logspace(0,2,4);
augs = round([0,logspace(0,log10(100),3)]);
[cR, nA] = ndgrid(costRatios, augs);
cR = reshape(cR, 1, numel(cR));
nA = reshape(nA, 1, numel(nA));

GRID_SIZE = numel(cR);

progressbar = ProgressBar(GRID_SIZE, 'Title', 'Grid search');

disp(['RUSBoost: cost/aug search'])

progressbar.setup([],[],[]);

for i = 1:GRID_SIZE
    costRatio=cR(i);
    nAugment=nA(i);
    undersamplingRatio=0.3;

    hyperparams.CostRatio=costRatio;    %used to calculate weight vector in cvobjfun.m
    hyperparams.ScoreTransform='doublelogit';
    hyperparams.Cost=[0,1;costRatio,0];
    hyperparams.ClassNames=logical([0,1]);
    hyperparams.LearnRate=0.1;

    [objective(i), ~, userdata{i}] = cvobjfun(@fitRUSBoost, hyperparams, undersamplingRatio, ...
        nAugment, crossvalPartition, trainingFeatures, trainingData, trainingLabels, ...
        imageLabels, 'Progress', true, 'UseParallel', true);
    disp(objective(i))

    progressbar([], [], []);
end

progressbar.release();

result.objective = objective;
result.userdata = userdata;
[~, minIdx] = min(result.objective);
result.CostRatio = cR(minIdx);
result.nAugment = nA(minIdx);
result.UndersamplingRatio=undersamplingRatio;

save([trainingDir filesep 'augCostTuningRUS.mat'],...
    'result', 'result', '-v7.3');
