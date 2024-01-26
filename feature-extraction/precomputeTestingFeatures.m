function precomputeTestingFeatures

% SPDX-License-Identifier: BSD-3-Clause

%% Setup
if isempty(gcp('nocreate'))
    parpool();
end

beehiveDataSetup;

%% Load data
load(testingDataDir + filesep + "testingData","testingData","testingMetadata")


%% Extract features
testingFeatures = cell(size(testingData));

parfor i = 1:numel(testingData)
    % Compute the average PRF; downstream feature extraction functions
    % need to know the sampling frequency
    fs = averagePRF(testingMetadata(i).Timestamps);

    testingFeatures{i} = extractFeatures(testingData{i},fs);
end
    

%% Save data 
save(testingDataDir + filesep + "testingFeatures.mat", ...
    "testingFeatures", "-v7.3");
