% SPDX-License-Identifier: BSD-3-Clause
function combineDataForTrainingTesting

beehiveDataSetup;

FOLDER_PREFIX = "MSU-horticulture-farm-bees-";

%% Combine training data
% The training data is the data taken in June: 2022-06-23 and 2022-06-24
juneDays = ["2022-06-23", "2022-06-24"];
juneFolderTimestamps0623 = ["122126" "135615" "141253" "144154" "145241"];
juneFolderTimestamps0624 = ["094752" "095001" "104012" "105017" "110409" "111746" "113017" "114343" "115816"];
juneFolderTimestamps = {juneFolderTimestamps0623, juneFolderTimestamps0624};

[juneData,juneRowLabels,juneImgLabels,juneMetadata] = combineData(juneDays, ...
    FOLDER_PREFIX, juneFolderTimestamps, rawDataDir);

%% Combine testing data
% The testing data is the data taken in July: 2022-07-28 and 2022-07-29
julyDays = ["2022-07-28", "2022-07-29"];
julyFolderTimestamps0728 = ["112652" "120850" "123948" "124905" "131133" "133834" "135906" "141427" "143013" "144821"];
julyFolderTimestamps0729 = ["093945" "095958" "101924"];
julyFolderTimestamps = {julyFolderTimestamps0728, julyFolderTimestamps0729};

[julyData,julyRowLabels,julyImgLabels,julyMetadata] = combineData(julyDays, ...
    FOLDER_PREFIX, julyFolderTimestamps, rawDataDir);


%% Save data
if ~exist(combinedDataDir)
    mkdir(baseDataDir, "combined");
end
save(combinedDataDir + filesep + "2022-06-combined.mat", ...
    'juneData', 'juneRowLabels', 'juneImgLabels', ...
    'juneMetadata', '-v7.3');
save(combinedDataDir + filesep + "2022-07-combined.mat", ...
    'julyData', 'julyRowLabels', 'julyImgLabels', ...
    'julyMetadata', '-v7.3');

end