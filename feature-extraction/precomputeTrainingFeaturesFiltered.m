% SPDX-License-Identifier: BSD-3-Clause
%% Setup
if isempty(gcp('nocreate'))
    parpool();
end

%% Load data
load(trainingDataDir + filesep + "trainingDataFiltered","trainingData","trainingMetadata")


%% Extract features
trainingFeatures = cell(size(trainingData));

parfor i = 1:numel(trainingData)
    % Compute the average PRF; downstream feature extraction functions
    % need to know the sampling frequency
    fs = averagePRF(trainingMetadata(i).Timestamps);

    trainingFeatures{i} = extractFeatures(trainingData{i},fs);
end
    

%% Save data 
save(trainingDataDir + filesep + "trainingFeaturesFiltered.mat", ...
    "trainingFeatures", "-v7.3");
