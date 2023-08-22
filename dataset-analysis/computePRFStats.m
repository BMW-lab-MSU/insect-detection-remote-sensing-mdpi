%% Load in meatadata

load(combinedDataDir + filesep + "2022-06-combined", "juneMetadata")
load(combinedDataDir + filesep + "2022-07-combined", "julyMetadata")

%% Combine metadata into one variable for easier analysis

metadata = horzcat(juneMetadata,julyMetadata);

%% compute the average PRF for each image

meanPRF = averagePRF(vertcat(metadata.Timestamps))