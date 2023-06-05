function remove = randomUndersample(labels, undersampleClass, opts)
% randomUndersample randomly undersample a given class label
%
%   randomUndersample returns indices of majority class samples; these indices
%   can be used to remove the samples from the dataset. Indices are returned
%   because of memory-usage considerations. If the labels and data matrix were
%   modified in-place with this function, MATLAB would create copies of the
%   matrices, which would result in extra memory usage.
%
%   remove = randomUndersample(labels, undersample_class) returns indices for
%   a random subset of 75% of the labels corresponding to the undersample_class
%   label.
%
%   remove = randomUndersample(labels, undersample_class, ...
%   'UndersamplingRatio', ratio) undersamples the undersample_class by ratio,
%   which must be between 0 and 1.

% SPDX-License-Identifier: BSD-3-Clause

arguments
    labels (1,:) 
    undersampleClass (1,1)
    opts.UndersamplingRatio (1,1) double {mustBeInRange(opts.UndersamplingRatio, 0, 1)} = 0.75
    opts.Reproducible (1,1) logical = false
    opts.Seed (1,1) uint32 {mustBeNonnegative} = 0
end

if opts.Reproducible
    rng(opts.Seed, 'twister');
end

idx = find(labels == undersampleClass);
remove = idx(randperm(numel(idx), ceil(opts.UndersamplingRatio * numel(idx))));