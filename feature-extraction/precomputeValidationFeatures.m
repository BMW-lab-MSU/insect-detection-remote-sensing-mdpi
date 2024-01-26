function precomputeValidationFeatures

% SPDX-License-Identifier: BSD-3-Clause

%% Setup
if isempty(gcp('nocreate'))
    parpool();
end

beehiveDataSetup;

%% Load data
load(validationDataDir + filesep + "validationData","validationData","validationMetadata")


%% Extract features
validationFeatures = cell(size(validationData));

parfor i = 1:numel(validationData)
    % Compute the average PRF; downstream feature extraction functions
    % need to know the sampling frequency
    fs = averagePRF(validationMetadata(i).Timestamps);

    validationFeatures{i} = extractFeatures(validationData{i},fs);
end
    

%% Save data 
save(validationDataDir + filesep + "validationFeatures.mat", ...
    "validationFeatures", "-v7.3");
