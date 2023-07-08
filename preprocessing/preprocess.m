% SPDX-License-Identifier: BSD-3-Clause

%% Load in data
filenames = ["2022-06-combined", "2022-07-combined"];

for filename = filenames
    load(combinedDataDir + filesep + filename)
end

%% Threshold data to reduce PMT ringing
% PMT rigning manifests as data > 0 volts, so we can threshold all positive values to 0.
% This doesn't reduce all ringing artifacts, but it helps.
% NOTE: this could be turned into a function later if we do more preprocessing and 
%       want to make this more modular.

for i = 1:numel(juneData)
    imgMean = mean(juneData{i},"all");
    juneData{i}(juneData{i} > 0) = imgMean;
end

for i = 1:numel(julyData)
    imgMean = mean(julyData{i},"all");
    julyData{i}(julyData{i} > 0) = imgMean;
end

%% Save data
if ~exist(preprocessedDataDir)
    mkdir(baseDataDir, "preprocessed");
end
save(preprocessedDataDir + filesep + "2022-06-preprocessed.mat", ...
    'juneData', 'juneRowLabels', 'juneImgLabels', ...
    'juneMetadata', '-v7.3');
save(preprocessedDataDir + filesep + "2022-07-preprocessed.mat", ...
    'julyData', 'julyRowLabels', 'julyImgLabels', ...
    'julyMetadata', '-v7.3');

