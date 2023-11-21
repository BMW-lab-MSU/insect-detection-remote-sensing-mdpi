% SPDX-License-Identifier: BSD-3-Clause
function splitData
%% Setup
% Set random number generator properties for reproducibility
rng(0, 'twister');

%% Load data
% The June days are being used as the training/validation set and the July days
% are used as the testing set. This emulates a scenario where you collect data,
% train, then test the models during the next data collection campaign.
beehiveDataSetup;

% load training data
load(preprocessedDataDir + filesep + "2022-06-preprocessed")

% load testing data
load(preprocessedDataDir + filesep + "2022-07-preprocessed")

%% Partition training data into train and validations sets
VALIDATION_PCT = 0.2;

holdoutPartition = cvpartition(juneImgLabels, 'Holdout', VALIDATION_PCT, 'Stratify', true);

trainingData = juneData(training(holdoutPartition));
validationData = juneData(test(holdoutPartition));
trainingImgLabels = juneImgLabels(training(holdoutPartition));
validationImgLabels = juneImgLabels(test(holdoutPartition));
trainingRowLabels = juneRowLabels(training(holdoutPartition));
validationRowLabels = juneRowLabels(test(holdoutPartition));
trainingRowConfidence = juneRowConfidence(training(holdoutPartition));
validationRowConfidence = juneRowConfidence(test(holdoutPartition));
trainingMetadata = juneMetadata(training(holdoutPartition));
validationMetadata = juneMetadata(test(holdoutPartition));

%% Rename testing data variables
testingData = julyData;
testingImgLabels = julyImgLabels;
testingRowLabels = julyRowLabels;
testingRowConfidence = julyRowConfidence;
testingMetadata = julyMetadata;


%% Save training and testing data
if ~exist(testingDataDir)
    mkdir(baseDataDir, "testing");
end
save(testingDataDir + filesep + "testingData.mat", ...
    'testingData', 'testingRowLabels', 'testingRowConfidence', ...
    'testingImgLabels', 'testingMetadata', '-v7.3');

if ~exist(trainingDataDir)
    mkdir(baseDataDir, "training");
end
save(trainingDataDir + filesep + "trainingData.mat", ...
    'trainingData', 'trainingRowLabels', 'trainingRowConfidence', ...
    'trainingImgLabels', 'trainingMetadata', 'holdoutPartition', '-v7.3');

if ~exist(validationDataDir)
    mkdir(baseDataDir, "validation");
end
save(validationDataDir + filesep + "validationData.mat", ...
    'validationData', 'validationRowLabels', 'validationRowConfidence', ...
    'validationImgLabels', 'validationMetadata', 'holdoutPartition', '-v7.3');

end
