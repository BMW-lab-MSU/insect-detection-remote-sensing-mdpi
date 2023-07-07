function rowLabels = createRowLabelVectors(csvFile, nImages, nRows)

    labelTable = readtable(csvFile);

    rowLabels = mat2cell(false(nRows, nImages), nRows, ones(nImages, 1))';

    nInsects = height(labelTable);

    for insectNum = 1:nInsects
        insect = labelTable(insectNum, :);

        % NOTE: in the future, we may want to exclude insects with
        % confidence == 1, or we may want to keep separate classes for each
        % confidence level; for now, we're just collapsing all insect
        % labels into a binary classification problem

        rowLabels{insect.imageNum}(insect.startRow:insect.endRow) = true;
    end
end



    
