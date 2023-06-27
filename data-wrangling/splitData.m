% SPDX-License-Identifier: BSD-3-Clause
%% Setup
% Set random number generator properties for reproducibility
rng(0, 'twister');

FOLDER_PREFIX = "MSU-horticulture-farm-bees-";

%% Combine training data
% The training data is the data taken in June: 2022-06-23 and 2022-06-24
trainingDays = ["2022-06-23", "2022-06-24"];
trainingFolderTimestamps0623 = ["122126" "135615" "141253" "144154" "145241"];
trainingFolderTimestamps0624 = ["094752" "095001" "104012" "105017" "110409" "111746" "113017" "114343" "115816"];
trainingFolderTimestamps = {trainingFolderTimestamps0623, trainingFolderTimestamps0624};

[trainValData,trainValRowLabels,trainValImgLabels,trainValMeta] = combineData(trainingDays, ...
    FOLDER_PREFIX, trainingFolderTimestamps, rawDataDir);

%% Combine testing data
% The testing data is the data taken in July: 2022-07-28 and 2022-07-29
testingDays = ["2022-07-28", "2022-07-29"];
testingFolderTimestamps0728 = ["112652" "120850" "123948" "124905" "131133" "133834" "135906" "141427" "143013" "144821"];
testingFolderTimestamps0729 = ["093945" "095958" "101924"];
testingFolderTimestamps = {testingFolderTimestamps0728, testingFolderTimestamps0729};

[testingData,testingRowLabels,testingImgLabels,testingMetadata] = combineData(testingDays, ...
    FOLDER_PREFIX, testingFolderTimestamps, rawDataDir);


%% Partition training data into train and validations sets

VALIDATION_PCT = 0.2;

holdoutPartition = cvpartition(trainValImgLabels, 'Holdout', VALIDATION_PCT, 'Stratify', true);

trainingData = trainValData(training(holdoutPartition));
validationData = trainValData(test(holdoutPartition));
trainingImgLabels = trainValImgLabels(training(holdoutPartition));
validationImgLabels = trainValImgLabels(test(holdoutPartition));
trainingRowLabels = trainValRowLabels(training(holdoutPartition));
validationRowLabels = trainValRowLabels(test(holdoutPartition));
trainingMetadata = trainValMeta(training(holdoutPartition));
validationMetadata = trainValMeta(test(holdoutPartition));


%% Save training and testing data
if ~exist(testingDataDir)
    mkdir(baseDataDir, "testing");
end
save(testingDataDir + filesep + "testingData.mat", ...
    'testingData', 'testingRowLabels', 'testingImgLabels', ...
    'testingMetadata', '-v7.3');

if ~exist(trainingDataDir)
    mkdir(baseDataDir, "training");
end
save(trainingDataDir + filesep + "trainingDataNoSparseCoding.mat", ...
    'trainingData', 'trainingRowLabels', 'trainingImgLabels', ...
    'trainingMetadata', 'holdoutPartition', '-v7.3');

if ~exist(validationDataDir)
    mkdir(baseDataDir, "validation");
end
save(validationDataDir + filesep + "valiationDataNoSparseCoding.mat", ...
    'validationData', 'validationRowLabels', 'validationImgLabels', ...
    'validationMetadata', 'holdoutPartition', '-v7.3');