function features = extractHarmonicFeatures(psd, nHarmonics, opts)
% extractHarmonicFeatures extract features related to harmonics in the PSD.
%
%   features = extractHarmonicFeatures(psd, nHarmonics) extracts features from
%   the power spectral density, psd, for nHarmonics harmonics. psd is a
%   one-sided power spectral density magnitude, i.e. abs(fft(X).^2). 
%
%   The extracted features for each harmonic are:
%       'HarmonicHeight'            - The height of the harmonic
%       'HarmonicLoc'               - The harmonic location (frequency bin)
%       'HarmonicWidth'             - The harmonic's half-prominence peak width
%       'HarmonicProminence'        - The harmonic's prominence
%
%   The extracted features for all combinations of n-choose-2 harmonics are:
%       'HarmonicHeightRatio'       - The ratio between harmonic heights
%       'HarmonicWidthRatio'        - The ratio between harmonic widths
%       'HarmonicProminenceRatio'   - The ratio between harmonic prominences

% SPDX-License-Identifier: BSD-3-Clause

% TODO: make nBins an input parameter
arguments
    psd (:,:) {mustBeNumeric}
    nHarmonics (1,1) double
    opts.UseParallel (1,1) logical = false
end

nBins = 2;
nRows = height(psd);

harmonicCombinations = nchoosek(1:nHarmonics, 2);
nHarmonicCombinations = height(harmonicCombinations);

peakHeight = cell(nRows, 1);
peakLoc = cell(nRows, 1);
peakWidth = cell(nRows, 1);
peakProminence = cell(nRows, 1);

harmonicHeight = nan(nRows, nHarmonics, 'like', psd);
harmonicLoc = nan(nRows, nHarmonics, 'like', psd);
harmonicWidth = nan(nRows, nHarmonics, 'like', psd);
harmonicProminence = nan(nRows, nHarmonics, 'like', psd);
harmonicHeightRatio = nan(nRows, nHarmonicCombinations, 'like', psd);
harmonicWidthRatio = nan(nRows, nHarmonicCombinations, 'like', psd);
harmonicProminenceRatio = nan(nRows, nHarmonicCombinations, 'like', psd);

fundamental = estimateFundamentalFreq(psd, 'UseParallel', opts.UseParallel);

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end

parfor (i = 1:nRows, nWorkers)
    % Get features for all peaks
    [peakHeight{i}, peakLoc{i}, peakWidth{i}, peakProminence{i}] = findpeaks(psd(i,:));
    peakHeight{i} = single(peakHeight{i});
    peakLoc{i} = single(peakLoc{i});
    peakWidth{i} = single(peakWidth{i});
    peakProminence{i} = single(peakProminence{i});
end

for i = 1:nRows
    % Grab the peaks that are harmonics of the fundamental
    [harmonicLoc(i,:), harmonicIdx] = findHarmonics(peakLoc{i}, fundamental(i), nHarmonics);
    
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
    features.(['HarmonicLoc' num2str(n)]) = harmonicLoc(:, n);
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
