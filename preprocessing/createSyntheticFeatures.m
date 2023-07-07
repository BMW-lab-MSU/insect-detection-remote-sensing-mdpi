function [newFeatures, labels] = createSyntheticFeatures(data, labels, nAugmented, avgSamplingFrequency, opts)

% SPDX-License-Identifier: BSD-3-Clause
arguments
    data (:,:) {mustBeNumeric}
    labels (:, 1) logical
    nAugmented (1,1) {mustBeNumeric, mustBeNonnegative}
    avgSamplingFrequency (1,1) {mustBeNumeric}
    opts.UseParallel (1,1) logical = false
end

% Return early if we aren't creating synthetic insects or if there aren't any
% insects in the data.
if nAugmented == 0 || ~any(labels)
    newFeatures = table.empty;
    labels = logical.empty;
    return
end

synthData = createSyntheticData(data, labels, nAugmented, 'UseParallel', opts.UseParallel);

newFeatures = extractFeatures(synthData, avgSamplingFrequency, 'UseParallel', opts.UseParallel);

labels = true(height(newFeatures), 1);
end

