function imageLabels = createImageLabelVector(csvFile, nImages)

    labelTable = readtable(csvFile);

    imageLabels = false(nImages, 1);

    nInsects = height(labelTable);

    for insectNum = 1:nInsects
        insect = labelTable(insectNum, :);

        imageLabels(insect.imageNum) = true;
    end
end



    