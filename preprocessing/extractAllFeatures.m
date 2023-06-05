% SPDX-License-Identifier: BSD-3-Clause
%% Setup
if isempty(gcp('nocreate'))
    parpool();
end

rawDataFile = 'scans.mat';

%% Load data
load([combinedDataDir filesep rawDataFile])


%% Extract features
for scanNum = progress(1:numel(scans))
    scanFeatures = cellfun(@(X) extractFeatures(X, 'UseParallel', true), ...
        scans(scanNum).Data, 'UniformOutput', false);
    scans(scanNum).Features = scanFeatures;
end


%% Save preprocessed data
if ~exist(preprocessedDataDir)
    mkdir(preprocessedDataDir);
end
save([preprocessedDataDir filesep 'preprocessedScans.mat'], ...
    'scans', '-v7.3');
