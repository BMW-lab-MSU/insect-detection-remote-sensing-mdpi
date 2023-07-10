function features = extractTimeDomainFeatures(X)
% extractTimeDomainFeatures extract features from time-domain lidar images for
% insect detection
%
%   features = extractTimeDomainFeatures(X) extracts features from the data
%   matrix, X, and returns the features as a table. Observations are rows in X.
%
%   The extracted features are:
%       'RowMeanMinusImageMean' - The mean of the obvservation minus the mean
%                                 of the entire image
%       'Range'                 - The range of each row
%       'StdDev'                - The standard deviation of each row
%       'MaxFirstDiff'          - The maximum absolute first difference in each row
%       'MaxSecondDiff'         - The maximum absolute second difference in each row
%       'RMS'                   - The root mean square of each row
%       'ImpulseFactor'         - The impulse factor of each row; this is the ratio
%                                 of the max absolute value over the mean absolute value
%       'CresetFactor'          - The crest factor of each row; this is the max absolute
%                                 value divided by the rms
%       'ShapeFactor'           - The shape factor of each row; this is the rms divided
%                                 by the mean absolute value
%       'Median'                - The median value of each row
%       'MAD'                   - The median absolute deviation of each row
%       'Skewness'              - The mean-centered skewness of each row
%       'Kurtosis'              - The mean-centered kurtosis of each row

% SPDX-License-Identifier: BSD-3-Clause

rowMean = mean(X, 2);
absMean = mean(abs(X),2);
imageMean = mean(X(:));

rowRange = range(X,2);

rowStd = std(X, 0, 2);

firstDiff = diff(X,1,2);
secondDiff = diff(firstDiff,1,2);

maxFirstDiff = max(abs(firstDiff),[],2);
maxSecondDiff = max(abs(secondDiff),[],2);

rootMeanSqaure = rms(X,2);

peakValue = max(abs(X),[],2);

impulseFactor = peakValue ./ absMean;

crestFactor = peakValue ./ rootMeanSqaure;

shapeFactor = rootMeanSqaure ./ absMean;

% mean-cenetered skewness
skew = skewness(X,1,2);
skew = skew - mean(skew);

% mean-cenetered kurtosis
k = kurtosis(X,1,2);
k = k - mean(k);

medianAbsDev = mad(X,1,2);

med = median(X,2);

features = table;
features.RowMeanMinusImageMean = rowMean - imageMean;
features.Range = rowRange;
features.StdDev = rowStd;
features.MaxFirstDiff = maxFirstDiff;
features.MaxSecondDiff = maxSecondDiff;
features.RMS = rootMeanSqaure;
features.ImpulseFactor = impulseFactor;
features.CrestFactor = crestFactor;
features.ShapeFactor = shapeFactor;
features.Median = med;
features.MAD = medianAbsDev;
features.Skewness = skew;
features.Kurtosis = k;

end
