function [newFeatures, labels] = dataAugmentation(data, labels, nAugmented, opts)

% SPDX-License-Identifier: BSD-3-Clause
arguments
    data (:,:) {mustBeNumeric}
    labels (:, 1) logical
    nAugmented (1,1) {mustBeNumeric, mustBeNonnegative}
    opts.UseParallel (1,1) logical = false
end

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end


synthData = createSyntheticData(data, labels, nAugmented, 'UseParallel', opts.UseParallel);

newFeatures = extractFeatures(synthData, 'UseParallel', opts.UseParallel);

labels = true(height(newFeatures), 1);
end

