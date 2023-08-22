%% Load in meatadata

load(combinedDataDir + filesep + "2022-06-combined", "juneMetadata")
load(combinedDataDir + filesep + "2022-07-combined", "julyMetadata")

%% Combine metadata into one variable for easier analysis

metadata = horzcat(juneMetadata,julyMetadata);

%% Compute image duration stats

imageDurations = range(vertcat(metadata.Timestamps),2);
avgImageDuration = mean(imageDurations)
maxImageDuration = max(imageDurations)
minImageDuration = min(imageDurations)