function imageLabels = createImageLabelVector(csvFile, nImages)
% createImageLabelVector create an image label vector from the csv labels.
%
% imageLabels = createImageLabelVector(csvFile,nImages) returns an nImages-by-1
% vector of labels indicating which images contain insects. The csvFile contains
% the original labels.

% SPDX-License-Identifier: BSD-3-Clause

    labelTable = readtable(csvFile);

    imageLabels = false(nImages, 1);

    nInsects = height(labelTable);

    for insectNum = 1:nInsects
        insect = labelTable(insectNum, :);

        imageLabels(insect.imageNum) = true;
    end
end



    