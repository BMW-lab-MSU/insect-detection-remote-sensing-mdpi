function labels = extractLabels(insects, datastruct)
% extract_labels Extract labels for a single data collection run
%
%   labels = extract_labels(insects, datastruct) returns a cell 
%   array of label vectors, where each cell corresponds to an 
%   element of datastruct. datastruct is expected to be from an
%   adjusted_data_decembercal.mat file. insects needs to be the
%   insects field of the fftcheck.mat file associated with datastruct. 
%
%   Example: labels = extract_labels(fftcheck.insects, adjusted_data_decembercal)

% SPDX-License-Identifier: BSD-3-Clause

[nrows, ncolumns] = size(datastruct(1).normalized_data);
labels = cell(numel(datastruct), 1);

% by construction, the first part of the filename for all structs in 
% datastruct (adjusted_data_decembercal) are the same folder name
temp = split(datastruct(1).filename, '/');
folder_name = temp{1};

% datastruct contains multiple images, each for a different pan/tilt angle
% combination
for image_num = 1:numel(datastruct)
    image_labels = false(nrows, 1);

    for insect_num = 1:numel(insects)

        % make sure the insect was from the same folder as datastruct
        if strcmp(insects(insect_num).name, folder_name)
            if insects(insect_num).filenum == image_num
                % extract the range bin the insect was found in
                % and label that row as a hit
                image_labels(insects(insect_num).range) = true;
            end
        end

        labels{image_num} = image_labels;
    end
end