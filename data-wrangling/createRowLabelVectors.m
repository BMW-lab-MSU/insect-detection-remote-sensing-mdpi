function [rowLabels,rowConfidence] = createRowLabelVectors(csvFile, nImages, nRows)
% createRowlabelVectors convert csv labels into vectors of row labels.
%
% [rowLabels,rowConfidence] = createRowLabelVectors(csvFile,nImages,nRows)
% takes the labels csv file, and returns an nImages-by-1 cell array containing
% the row labels for each image. Each cell contains an nRows-by-1 vector where
% each element indicates whether there's an insect in that row. The function
% also returns a cell array containing the confidence ratings for each row in
% each image.

% SPDX-License-Identifier: BSD-3-Clause

    labelTable = readtable(csvFile);

    rowLabels = mat2cell(false(nRows, nImages), nRows, ones(nImages, 1))';
    rowConfidence = mat2cell(zeros(nRows, nImages,'uint8'), nRows, ones(nImages, 1))';

    nInsects = height(labelTable);

    for insectNum = 1:nInsects
        insect = labelTable(insectNum, :);

        % NOTE: in the future, we may want to exclude insects with
        % confidence == 1, or we may want to keep separate classes for each
        % confidence level; for now, we're just collapsing all insect
        % labels into a binary classification problem

        rowLabels{insect.imageNum}(insect.startRow:insect.endRow) = true;
        rowConfidence{insect.imageNum}(insect.startRow:insect.endRow) = insect.confidence;
    end
end



    
