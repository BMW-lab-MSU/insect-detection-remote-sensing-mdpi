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

costRatios = logspace(0,2,4);

GRID_SIZE = numel(costRatios);

progressbar = ProgressBar(GRID_SIZE, 'Title', 'Grid search');

disp(['CNN: class weight search'])

progressbar.setup([],[],[]);

for i = 1:GRID_SIZE
    costRatio=costRatios(i);
    undersamplingRatio=0.3;

    hyperparams.UndersamplingRatio = undersamplingRatio;
    hyperparams.CostRatio=costRatio;    %used to calculate weight vector in cvobjfun.m
    hyperparams.Cost=[1,costRatio];
    hyperparams.Cost = hyperparams.Cost / mean(hyperparams.Cost);


    [objective(i), ~, userdata{i}] = cvCnn2dObjFun(@fitCnn2dSmall, hyperparams, ...
        crossvalPartition, trainingData, trainingLabels, ...
        'Progress', false, 'UseParallel', true);

    disp('')
    disp(objective(i))
    disp('')
    disp(hyperparams.Cost)

    progressbar([],[],[]);

end

progressbar.release();

result.objective = objective;
result.userdata = userdata;
[~, minIdx] = min(result.objective);
result.CostRatio = costRatios(minIdx);
result.UndersamplingRatio = undersamplingRatio;

save([trainingDir filesep 'tuningCNN2dSmall.mat'],...
    'result', 'result', '-v7.3');
