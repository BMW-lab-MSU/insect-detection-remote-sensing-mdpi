% SPDX-License-Identifier: BSD-3-Clause
%% Setup
rng(0, 'twister');

datadir = '../data';
waveletdir = [datadir filesep 'training' filesep 'wavelets'];

% if isempty(gcp('nocreate'))
%     parpool('IdleTimeout', Inf);
% end

%% Load data
load([datadir filesep 'training' filesep 'trainingData.mat'], 'trainingLabels', 'crossvalPartition');

% trainingLabels = categorical(vertcat(trainingLabels{:}));

waveletFileset = matlab.io.datastore.FileSet([waveletdir filesep 'trainingWaveletMagnitude*.tiff']);
wavelets = imageDatastore(waveletFileset, 'ReadSize', 128);
wavelets.Labels = categorical(vertcat(trainingLabels{:}));


%% "tune" parameters; for now, just checking if the framework works...

% empty struct for now since we aren't tuning anything
hyperparams = struct();

[objective, ~, userdata] = cvCnn2dWaveletObjFun(@fitCnn2dWavelets, hyperparams, ...
    crossvalPartition, wavelets, trainingLabels, ...
    'Progress', true, 'UseParallel', true);


result.objective = objective;
result.userdata = userdata;
[~, minIdx] = min(result.objective);

% save([datadir filesep 'training' filesep 'augCostTuningADA.mat'],...
    % 'result', 'result', '-v7.3');
