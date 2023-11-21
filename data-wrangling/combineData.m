function [data, rowLabels, rowConfidence, imgLabels, metadata] = combineData(dates, folderPrefix, folderTimestamps, rawDataDir)
% SPDX-License-Identifier: BSD-3-Clause

% TODO: argument validation

% TODO make these (optional) arguments
DATA_FILENAME = "adjusted_data_junecal_volts.mat";
LABELS_FILENAME = "labels.mat";


%% Create initial data structures
metadata = struct('Day', string(), 'FolderName', string(), 'FileName', string(), 'Pan', {}, ...
    'Tilt', {}, 'Range', {}, 'Timestamps', {});

data = {};
rowLabels = {};
rowConfidence = {};
imgLabels = false;

%% Folder Setup
globalImageNum = 0;
for index = 1:length(dates)
    date = dates(index);
    scanNums = folderTimestamps{index};

    for scanNum = 1:length(scanNums)


        filePath = rawDataDir + filesep + date + filesep + folderPrefix + scanNums(scanNum);

        % load data
        load(filePath + filesep + DATA_FILENAME);

        % load labels
        labels = load(filePath + filesep + LABELS_FILENAME);

        numImages = numel(adjusted_data_junecal);

        for scanImageNum = 1:numImages
            globalImageNum = globalImageNum + 1;


            data{globalImageNum} = adjusted_data_junecal(scanImageNum).data;

            rowLabels(globalImageNum) = labels.rowLabels(scanImageNum);
            rowConfidence(globalImageNum) = labels.rowConfidence(scanImageNum);
            imgLabels(globalImageNum) = labels.imageLabels(scanImageNum); 

            metadata(globalImageNum).Day = date;
            metadata(globalImageNum).FolderName = folderPrefix + scanNums(scanNum);
            metadata(globalImageNum).Pan = adjusted_data_junecal(scanImageNum).pan;
            metadata(globalImageNum).Tilt = adjusted_data_junecal(scanImageNum).tilt;
            metadata(globalImageNum).Range = adjusted_data_junecal(scanImageNum).range;
            metadata(globalImageNum).Timestamps = adjusted_data_junecal(scanImageNum).time;
            
            % the filename field is really <foldername>/<filename>, so we get rid of the 
            % the foldername here since we already have that information
            tmp = split(adjusted_data_junecal(scanImageNum).filename, '/');
            metadata(globalImageNum).FileName = string(tmp{2});
        end


    end

end
