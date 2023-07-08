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

%% Highpass filter the data
% TODO: udpate comment after this works or doesn't...
% The passband is set to 50--1200 Hz. Honeybee wingbeat frequencies are 
% typically between 100 and 500 Hz, usually on the lower end of the range.
% We want to pass at least the 3rd harmonic for the bees, so the upper
% passband frequency is set to 1200 Hz, which is hte 3rd harmonic for 400 Hz.
% The bee signals we've looked at have fundamentals between 100--200 Hz.
%
% We use a Butterworth filter so we have a maximally flat passband.
cutoff = 50;
filterOrder = 4;

parfor i = 1:numel(juneData)
    % Compute the average PRF for the image so we can scale the passband
    % frequencies into normalized frequencies.
    fs = averagePRF(juneMetadata(i).Timestamps);

    juneData{i} = highpassFilter(juneData{i},filterOrder,cutoff,fs);
end

parfor i = 1:numel(julyData)
    fs = averagePRF(julyMetadata(i).Timestamps);

    julyData{i} = highpassFilter(julyData{i},filterOrder,cutoff,fs);
end

%% Save data
if ~exist(preprocessedDataDir)
    mkdir(baseDataDir, "preprocessed");
end
save(preprocessedDataDir + filesep + "2022-06-preprocessed-filtered.mat", ...
    'juneData', 'juneRowLabels', 'juneImgLabels', ...
    'juneMetadata', '-v7.3');
save(preprocessedDataDir + filesep + "2022-07-preprocessed-filtered.mat", ...
    'julyData', 'julyRowLabels', 'julyImgLabels', ...
    'julyMetadata', '-v7.3');
