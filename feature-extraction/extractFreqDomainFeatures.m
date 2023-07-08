function features = extractFreqDomainFeatures(X, avgSamplingFrequency, opts)
% extractFreqDomainFeatures extract frequency-domain features for insect
% detection
%
%   features = extractFreqDomainFeatures(X) extracts features from the data %   %   matrix, X, and returns the features as a table. Observations are rows in X.
%
%   The extracted ESD statistics are:
%       'MeanEsd'                   - The mean of the ESD
%       'StdEsd'                    - The standard deviation of the ESD
%       'MedianEsd'                 - The median of the ESD
%       'MadEsd'                    - The median absolute deviation of the ESD
%       'SkewnessEsd'               - Zero-mean skewness of the ESD   
%       'KurtosisEsd'               - Zero-mean kurtosis of the ESD     
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

arguments
    X (:,:) {mustBeNumeric}
    avgSamplingFrequency (1,1) {mustBeNumeric}
    opts.UseParallel (1,1) logical = false
    opts.NHarmonics = 3
    opts.FilterPassband = [50 1200]
    opts.FilterOrder = 10
end

fftSize = width(X);

filtered = bandpassFilter(X,opts.FilterOrder,opts.FilterPassband,...
    avgSamplingFrequency);

esd = abs(fft(filtered, [], 2)).^2;

% Only look at the positive frequencies
esd = esd(:,1:end/2);

esdStats = extractEsdStats(esd);

harmonicFeatures = extractHarmonicFeatures(esd,opts.NHarmonics,...
    avgSamplingFrequency,fftSize,'UseParallel', opts.UseParallel);

features = [esdStats, harmonicFeatures];
end
