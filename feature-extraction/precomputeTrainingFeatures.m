% SPDX-License-Identifier: BSD-3-Clause
function precomputeTrainingFeatures

%% Setup
if isempty(gcp('nocreate'))
    parpool();
end

beehiveDataSetup;

%% Load data
load(trainingDataDir + filesep + "trainingData","trainingData","trainingMetadata")


%% Extract features
trainingFeatures = cell(size(trainingData));

parfor i = 1:numel(trainingData)
    % Compute the average PRF; downstream feature extraction functions
    % need to know the sampling frequency
    fs = averagePRF(trainingMetadata(i).Timestamps);

    trainingFeatures{i} = extractFeatures(trainingData{i},fs);
end
    

%% Save data 
save(trainingDataDir + filesep + "trainingFeatures.mat", ...
    "trainingFeatures", "-v7.3");
