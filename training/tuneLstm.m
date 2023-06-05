% SPDX-License-Identifier: BSD-3-Clause
%% Setup
rng(0, 'twister');

if isempty(gcp('nocreate'))
    numGPUs = gpuDeviceCount("available");
    parpool(numGPUs, 'IdleTimeout', Inf);
end

%% Load data
load([trainingDir filesep 'trainingData.mat']);


%% "tune" parameters; for now, just checking if the framework works...

% Create the grid
costRatios = logspace(0,2,4);
augs = round([0,logspace(0,log10(100),3)]);
[cR, nA] = ndgrid(costRatios, augs);
cR = reshape(cR, 1, numel(cR));
nA = reshape(nA, 1, numel(nA));

GRID_SIZE = numel(cR);

progressbar = ProgressBar(GRID_SIZE, 'Title', 'Grid search');
% empty struct for now since we aren't tuning anything
disp(['LSTM: grid search'])

progressbar.setup([],[],[]);

for i = 1:GRID_SIZE
    costRatio=cR(i);
    nAugment=nA(i);
    undersamplingRatio=0.3;

    hyperparams.UndersamplingRatio = undersamplingRatio;
    hyperparams.nAugment = nAugment;
    hyperparams.CostRatio=costRatio;    %used to calculate weight vector in cvobjfun.m
    hyperparams.Cost=[1,costRatio];
    hyperparams.Cost = hyperparams.Cost / mean(hyperparams.Cost);


    [objective(i), ~, userdata{i}] = cvCnn1dObjFun(@fitLstm, hyperparams, ...
        crossvalPartition, trainingData, trainingLabels, ...
        'Progress', false, 'UseParallel', false);

    disp(objective(i))

    progressbar([],[],[]);
end

progressbar.release();

result.objective = objective;
result.userdata = userdata;
[~, minIdx] = min(result.objective);
result.CostRatio = cR(minIdx);
result.nAugment = nA(minIdx);
result.UndersamplingRatio = undersamplingRatio;

save([trainingDir filesep 'tuningLstm.mat'],...
    'result', 'result', '-v7.3');
