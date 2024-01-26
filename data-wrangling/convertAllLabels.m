function convertAllLabels
% convertAllLabels convert labels from csv into mat files.
%
% The original labels, which are in csv format, specify each
% insect's bounding box. The algorithms need label vectors instead.
% This function converts the csv labels into row and image label vectors.
% Each data collection directory contains a labels csv file. This function
% creates a labels.mat file in each data collection directory.
%
% See also createRowLabelVectors, createImageLabelVectors

% SPDX-License-Identifier: BSD-3-Clause

beehiveDataSetup;

DATA_FILENAME = "adjusted_data_junecal_volts.mat";
LABEL_FILENAME = "labels.csv";

% Find date directories matching yyyy-mm-dd format, as this is where the data
% collections runs are stored
dirContents = dir(rawDataDir);
dateDirIndices = cellfun(@(c) ~isempty(c), regexp({dirContents.name}, "\d{4}-\d{2}-\d{2}"));
dateDirs = [string({dirContents(dateDirIndices).name})];

for date = dateDirs
    % find run folders; such folders end with a timestamp
    dirContents = dir(rawDataDir + filesep + date);
    runDirIndices = cellfun(@(c) ~isempty(c), regexp({dirContents.name}, "-\d{6}"));
    runDirs = [string({dirContents(runDirIndices).name})];

    for run = runDirs
        disp("converting " + date + filesep + run)
        
        % Get the number of rows in the images, as well as the number of images.
        % It's assumed that the number of rows is the same for each image in a % data collection run.
        dataFilepath = fullfile(rawDataDir, date, run, DATA_FILENAME);
        load(dataFilepath);

        nImages = numel(adjusted_data_junecal);
        nRows = size(adjusted_data_junecal(1).data, 1);

        % Convert the csv labels into row label and image label vectors.
        labelFilepath = fullfile(rawDataDir, date, run, LABEL_FILENAME);
        [rowLabels,rowConfidence] = createRowLabelVectors(labelFilepath, ...
            nImages, nRows);
        imageLabels = createImageLabelVector(labelFilepath, nImages);

        save(fullfile(rawDataDir, date, run, "labels.mat"), 'rowLabels', 'rowConfidence', 'imageLabels');
    end
end

end
