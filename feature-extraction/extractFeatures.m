function features = extractFeatures(X, avgSamplingFrequency, opts)
% extractFeatures extract features for insect detection
%
%   features = extractFeatures(X) extracts features from the data matrix, X,
%   and returns the features as a table. Observations are rows in X.
%
%   The extracted time-domain features are:
%       'RowMeanMinusImageMean' - The mean of the obvservation minus the mean
%                                 of the entire image
%       'StdDev'                - The standard deviation of each row
%       'MaxDiff'               - The maximum absolute first difference in a row
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
end

timeFeatures = extractTimeDomainFeatures(X);

freqFeatures = extractFreqDomainFeatures(X, avgSamplingFrequency, 'UseParallel', opts.UseParallel);
tfFeatures = extractTFFeatures(X, 'UseParallel', opts.UseParallel);
features = [timeFeatures, freqFeatures, tfFeatures]; % ,tfFeatures

% replace nans with zeros because we don't want the ML algorithms to throw out
% data points that have a few nan dimensions.
features = fillmissing(features,'constant',0);
end
