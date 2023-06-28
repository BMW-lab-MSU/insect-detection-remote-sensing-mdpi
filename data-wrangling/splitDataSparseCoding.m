% SPDX-License-Identifier: BSD-3-Clause
%% Setup
% Set random number generator properties for reproducibility
rng(0, 'twister');


%% Split training data for KSVD training
% KSVD will be trained on 10% of the training data, and that training data has to not contain insects.
% The other 90% of the training data will be left alone
KSVD_TRAIN_PCT = 0.1;

% Load training data
original = load(trainingDataDir + filesep + "trainingDataNoSparseCoding.mat");

nImages = numel(original.trainingImgLabels);

% find non-insect images
nonInsectImgIdx = find(original.trainingImgLabels == false);
numNonInsectImgs = numel(nonInsectImgIdx);

% select 10% of the non-insect images for KSVD training
rand10PctIdx = randperm(numNonInsectImgs, ceil(numNonInsectImgs * KSVD_TRAIN_PCT));

nonInsectImg10PctIdx = nonInsectImgIdx(rand10PctIdx);

% get the indices for the other 90% of the training data
trainingDataIdx = setdiff(1:nImages, nonInsectImg10PctIdx);

ksvdTrainingData = original.trainingData(nonInsectImg10PctIdx);
ksvdTrainingRowLabels = original.trainingRowLabels(nonInsectImg10PctIdx);
ksvdTrainingImgLabels = original.trainingImgLabels(nonInsectImg10PctIdx);
ksvdTrainingMetadata = original.trainingMetadata(nonInsectImg10PctIdx);

trainingData = original.trainingData(trainingDataIdx);
trainingRowLabels = original.trainingRowLabels(trainingDataIdx);
trainingImgLabels = original.trainingImgLabels(trainingDataIdx);
trainingMetadata = original.trainingMetadata(trainingDataIdx);

%% Split validation data
% We are reserving a portion of the validation data for ksvd parameter selection
KSVD_VALIDATION_PCT = 0.1;

% load validation data
originalVal = load(validationDataDir + filesep + "validationDataNoSparseCoding.mat");

holdoutPartition = cvpartition(originalVal.validationImgLabels, ...
    'Holdout', KSVD_VALIDATION_PCT, 'Stratify', true);

validationData = originalVal.validationData(training(holdoutPartition));
validationImgLabels = originalVal.validationImgLabels(training(holdoutPartition));
validationRowLabels = originalVal.validationRowLabels(training(holdoutPartition));
validationMetadata = originalVal.validationMetadata(training(holdoutPartition));

ksvdValidationData = originalVal.validationData(test(holdoutPartition));
ksvdValidationImgLabels = originalVal.validationImgLabels(test(holdoutPartition));
ksvdValidationRowLabels = originalVal.validationRowLabels(test(holdoutPartition));
ksvdValidationMetadata = originalVal.validationMetadata(test(holdoutPartition));

%% Save data 
if ~exist(trainingDataDir)
    mkdir(baseDataDir, "training");
end
save(trainingDataDir + filesep + "ksvdTrainingData.mat", ...
    'ksvdTrainingData', 'ksvdTrainingRowLabels', ...
    'ksvdTrainingImgLabels', 'ksvdTrainingMetadata', '-v7.3');

save(trainingDataDir + filesep + "trainingData.mat", ...
    'trainingData', 'trainingRowLabels', ...
    'trainingImgLabels', 'trainingMetadata', '-v7.3');

if ~exist(validationDataDir)
    mkdir(baseDataDir, "validation");
end
save(validationDataDir + filesep + "ksvdValidationData.mat", ...
    'ksvdValidationData', 'ksvdValidationRowLabels', ...
    'ksvdValidationImgLabels', 'ksvdValidationMetadata', '-v7.3');

save(validationDataDir + filesep + "validationData.mat", ...
    'validationData', 'validationRowLabels', ...
    'validationImgLabels', 'validationMetadata', '-v7.3');

