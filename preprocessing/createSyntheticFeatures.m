function [newFeatures, labels] = createSyntheticFeatures(data, labels, nAugmented, avgSamplingFrequency, opts)
% createSyntheticFeatures create synthetic features for minority class examples
%
%   [newFeatures,labels] = ...
%       createSyntheticFeatures(data,labels,nAugmented,avgSamplingFrequency)
%   creats nAugmented examples for each minority example in data. The minority
%   label is assumed to be 1. Synthetic features and associated synthetic labels
%   are returned. The average sampling frequency is required to extract
%   some frequency-domain features from the synthetic examples.
%
%   Name-value options:
%       UseParallel (logical):  - Use the Parallel Computing Toolbox
%       Reproducible (logical): - Make the results reproducible
%       Seed:                   - The seed for the random number generator if
%                                 Reproducible is true
%
%   See also createSynethicData

% SPDX-License-Identifier: BSD-3-Clause
arguments
    data (:,:) {mustBeNumeric}
    labels (:, 1) logical
    nAugmented (1,1) {mustBeNumeric, mustBeNonnegative}
    avgSamplingFrequency (1,1) {mustBeNumeric}
    opts.UseParallel (1,1) logical = false
    opts.Reproducible = false
    opts.Seed (1,1) uint32 {mustBeNonnegative} = 0
end

% Return early if we aren't creating synthetic insects or if there aren't any
% insects in the data.
if nAugmented == 0 || ~any(labels)
    newFeatures = table.empty;
    labels = logical.empty;
    return
end

synthData = createSyntheticData(data, labels, nAugmented, 'UseParallel', opts.UseParallel, ...
    'Reproducible', opts.Reproducible, 'Seed', opts.Seed);

newFeatures = extractFeatures(synthData, avgSamplingFrequency, 'UseParallel', opts.UseParallel);

labels = true(height(newFeatures), 1);
end

