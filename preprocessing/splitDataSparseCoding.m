% SPDX-License-Identifier: BSD-3-Clause
%% Setup
% Set random number generator properties for reproducibility
rng(0, 'twister');

%% Load training data
original = load(trainingDir + "trainingDataNoKSVD.mat");

nImages = numel(original.trainingImgLabels);

%% Split training data for KSVD training
% KSVD will be trained on 10% of the training data, and that training data has to not contain insects.
% The other 90% of the training data will be left alone
KSVD_TRAIN_PCT = 0.1;

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


%% Save data 
if ~exist(trainingDir)
    mkdir(baseDir, "training");
end
save(trainingDir + filesep + "ksvdTrainingData.mat", ...
    'ksvdTrainingData', 'ksvdTrainingRowLabels', ...
    'ksvdTrainingImgLabels', 'ksvdTrainingMetadata', '-v7.3');

save(trainingDir + filesep + "trainingData.mat", ...
    'trainingData', 'trainingRowLabels', ...
    'trainingImgLabels', 'trainingMetadata', '-v7.3');
