function features = extractHarmonicFeatures(esd, nHarmonics, avgSamplingFrequency, fftSize, opts)
% extractHarmonicFeatures extract features related to harmonics in the ESD.
%
%   features = extractHarmonicFeatures(esd, nHarmonics) extracts features from
%   the energy spectral density, esd, for nHarmonics harmonics. esd is a
%   one-sided energy spectral density magnitude, i.e. abs(fft(X).^2). 
%
%   The extracted features for each harmonic are:
%       'HarmonicHeight'            - The height of the harmonic
%       'harmonicFreq'              - The harmonic frequency in Hz
%       'HarmonicWidth'             - The harmonic's half-prominence peak width
%       'HarmonicProminence'        - The harmonic's prominence
%
%   The extracted features for all combinations of n-choose-2 harmonics are:
%       'HarmonicHeightRatio'       - The ratio between harmonic heights
%       'HarmonicWidthRatio'        - The ratio between harmonic widths
%       'HarmonicProminenceRatio'   - The ratio between harmonic prominences

% SPDX-License-Identifier: BSD-3-Clause
arguments
    esd (:,:) {mustBeNumeric}
    nHarmonics (1,1) {mustBeNumeric}
    avgSamplingFrequency (1,1) {mustBeNumeric}
    fftSize (1,1) {mustBeNumeric}
    opts.UseParallel (1,1) logical = false
end

nRows = height(esd);

harmonicCombinations = nchoosek(1:nHarmonics, 2);
nHarmonicCombinations = height(harmonicCombinations);

peakHeight = cell(nRows, 1);
peakLoc = cell(nRows, 1);
peakWidth = cell(nRows, 1);
peakProminence = cell(nRows, 1);

harmonicHeight = nan(nRows, nHarmonics, 'like', esd);
harmonicFreq = nan(nRows, nHarmonics, 'like', esd);
harmonicWidth = nan(nRows, nHarmonics, 'like', esd);
harmonicProminence = nan(nRows, nHarmonics, 'like', esd);
harmonicHeightRatio = nan(nRows, nHarmonicCombinations, 'like', esd);
harmonicWidthRatio = nan(nRows, nHarmonicCombinations, 'like', esd);
harmonicProminenceRatio = nan(nRows, nHarmonicCombinations, 'like', esd);

fundamental = estimateFundamentalFreq(esd);

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end

parfor (i = 1:nRows, nWorkers)
    % Get features for all peaks
    [peakHeight{i}, peakLoc{i}, peakWidth{i}, peakProminence{i}] = findpeaks(esd(i,:));
    peakHeight{i} = single(peakHeight{i});
    peakLoc{i} = single(peakLoc{i});
    peakWidth{i} = single(peakWidth{i});
    peakProminence{i} = single(peakProminence{i});
end

for i = 1:nRows
    % Grab the peaks that are harmonics of the fundamental
    [harmonicFreq(i,:), harmonicIdx] = findHarmonics(peakLoc{i}, fundamental(i), nHarmonics, avgSamplingFrequency, fftSize);
    
    % Get features for the harmonics. If a harmonic wasn't found, harmonicIdx
    % will be 0. All related features to be 0 if the harmonic wasn't found.
    for j = 1:numel(harmonicIdx)
        if harmonicIdx(j) ~= 0
            harmonicWidth(i,j) = peakWidth{i}(harmonicIdx(j));
            harmonicProminence(i,j) = peakProminence{i}(harmonicIdx(j));
            harmonicHeight(i,j) = peakHeight{i}(harmonicIdx(j));
        end
    end
    
    % Compute feature ratios for all n-choose-2 combinations of harmonics
    for n = 1:nHarmonicCombinations
        % Get the harmonic numbers we are taking a ratio of
        harmonic1 = harmonicCombinations(n, 1);
        harmonic2 = harmonicCombinations(n, 2);

        harmonicHeightRatio(i, n) = harmonicHeight(i, harmonic1) / harmonicHeight(i, harmonic2);

        harmonicWidthRatio(i, n) = harmonicWidth(i ,harmonic1) / harmonicWidth(i, harmonic2);

        harmonicProminenceRatio(i, n) = harmonicProminence(i ,harmonic1) / harmonicProminence(i, harmonic2);
    end
end

% Assemble features into our output table
features = table;

for n = 1:nHarmonics
    features.(['HarmonicHeight' num2str(n)]) = harmonicHeight(:, n);
    features.(['HarmonicFreq' num2str(n)]) = harmonicFreq(:, n);
    features.(['HarmonicWidth' num2str(n)]) = harmonicWidth(:, n);
    features.(['HarmonicProminence' num2str(n)]) = harmonicProminence(:, n);
end

for n = 1:nHarmonicCombinations
    ratioStr = strrep(num2str(harmonicCombinations(n,:)), ' ', '');
    features.(['HarmonicHeightRatio' ratioStr]) = harmonicHeightRatio(:, n);
    features.(['HarmonicWidthRatio' ratioStr]) = harmonicWidthRatio(:, n);
    features.(['HarmonicProminenceRatio' ratioStr]) = harmonicProminenceRatio(:, n);
end
end
