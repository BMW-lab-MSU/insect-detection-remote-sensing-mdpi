function [synthData,synthLabels] = createSyntheticData(data, labels, nAugmented, opts)
% createSyntheticData create synthetic examples of a minority class
%
%   [synthData,synthLabels] = createSyntheticData(data,labels,nAugmented)
%   creats nAugmented examples for each minority example in data. The minority
%   label is assumed to be 1. Synthetic data and associated synthetic labels
%   are returned.
%
%   Name-value options:
%       UseParallel (logical):  - Use the Parallel Computing Toolbox
%       Reproducible (logical): - Make the results reproducible
%       Seed:                   - The seed for the random number generator if
%                                 Reproducible is true

% SPDX-License-Identifier: BSD-3-Clause

arguments
    data (:,:) {mustBeNumeric}
    labels (:, 1) logical
    nAugmented (1,1) {mustBeNumeric, mustBeNonnegative}
    opts.UseParallel (1,1) logical = false
    opts.Reproducible = false
    opts.Seed (1,1) uint32 {mustBeNonnegative} = 0
end

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end

if opts.Reproducible
    rng(opts.Seed,'twister');
end

N_VARIATIONS = 6;

insectIdx = find(labels == 1);

% Return early if there aren't any insects in the data;
% we can't create synthetic insects if no insects are available :)
if isempty(insectIdx)
    synthData = [];
    synthLabels = logical.empty;
    return
end

nInsects = numel(insectIdx);
insectData = data(insectIdx,:);

synthDataCell = cell(nInsects, 1);

parfor (i = 1:nInsects, nWorkers)

    synthDataTmp = zeros(nAugmented, width(insectData), 'like', data);

    insect = insectData(i,:);

    stop = 0;

    for j = 1:ceil(nAugmented/N_VARIATIONS)
        variations = zeros(N_VARIATIONS, width(insectData), 'like', data);

        variations(1, :) = circshift(insect, randi(width(insectData), 1));
        variations(2, :) = fliplr(insect);
        variations(3, :) = interpolate(variations(1, :));
        variations(4, :) = decimate_(variations(1, :));
        variations(5, :) = interpolate(variations(2, :));
        variations(6, :) = decimate_(variations(2, :));

        % add noise to the variations
        variations = variations + ...
            randn(N_VARIATIONS, width(insectData), 'like', data) * ...
            max(variations, [], 'all')/2;

        % put the variations into the correct location in synthData
        if nAugmented < j * N_VARIATIONS
            nAugmentedLeft = mod(nAugmented, (j - 1) * N_VARIATIONS);
            
            start = stop + 1;
            stop = start + nAugmentedLeft - 1;
            
            if stop > height(synthDataTmp)
                stop = height(synthDataTmp)
            end
            
            synthDataTmp(start:stop, :) = variations(1:nAugmentedLeft, :);
        else
            start = stop + 1;
            stop = start + N_VARIATIONS - 1;
            
            if stop > height(synthDataTmp)
                stop = height(synthDataTmp)
            end
            
            synthDataTmp(start:stop, :) = variations;
        end
    end
    synthDataCell{i} = synthDataTmp;
end

synthData = cell2mat(synthDataCell);
synthLabels = true(height(synthData),1);
end


function y = interpolate(x)
    % interpolate by a factor of 3
    y = interp(x, 3);

    % remove random values until y is the same size as x
    y(randperm(width(y), width(y) - width(x))) = [];
end

function y = decimate_(x)
    % decimate by 2
    if ~isa(class(x), 'double')
        y = decimate(double(x), 2, 'FIR');
        y = cast(y, 'like', x);
    else
        y = decimate(x, 2, 'FIR');
    end


    % pad y with it's mean until it is the same size as x
    y = [y, repelem(mean(y), width(x) - width(y))];
end