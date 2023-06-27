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
        
        dataFilepath = fullfile(rawDataDir, date, run, DATA_FILENAME);
        load(dataFilepath);

        nImages = numel(adjusted_data_junecal);
        nRows = size(adjusted_data_junecal(1).data, 1);

        labelFilepath = fullfile(rawDataDir, date, run, LABEL_FILENAME);
        rowLabels = createRowLabelVectors(labelFilepath, nImages, nRows);
        imageLabels = createImageLabelVector(labelFilepath, nImages);

        save(fullfile(rawDataDir, date, run, "labels.mat"), 'rowLabels', 'imageLabels');
    end
end