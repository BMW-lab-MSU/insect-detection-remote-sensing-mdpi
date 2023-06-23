function [data, rowLabels, imgLabels, metadata] = combineData(dates, folderPrefix, folderTimestamps, rawDataDir)
% SPDX-License-Identifier: BSD-3-Clause

% TODO: argument validation

N_ROWS = 178;
N_COLS = 1024;

% TODO make these (optional) arguments
DATA_FILENAME = "adjusted_data_junecal_volts.mat";
LABELS_FILENAME = "labels.mat";


%% Create initial data structures
metadata = struct('Day', string(), 'FolderName', string(), 'FileName', string(), 'Pan', {}, ...
    'Tilt', {}, 'Range', {}, 'Timestamps', {});

data = {};
rowLabels = {};
imgLabels = [];

%% Folder Setup
imageNum = 0;
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

        for image = 1:numImages
            imageNum = imageNum + 1;


	    % conver data to single-precision to save RAM
            data{imageNum} = single(adjusted_data_junecal(scanNum).data);

            rowLabels(imageNum) = labels.rowLabels(scanNum);
            imgLabels(imageNum) = labels.imageLabels(scanNum); 

            metadata(imageNum).Day = date;
            metadata(imageNum).FolderName = folderPrefix + scanNums(scanNum);
            metadata(imageNum).Pan = adjusted_data_junecal(scanNum).pan;
            metadata(imageNum).Tilt = adjusted_data_junecal(scanNum).tilt;
            metadata(imageNum).Range = adjusted_data_junecal(scanNum).range;
            metadata(imageNum).Timestamps = adjusted_data_junecal(scanNum).time;
            
            % the filename field is really <foldername>/<filename>, so we get rid of the 
            % the foldername here since we already have that information
            tmp = split(adjusted_data_junecal(scanNum).filename, '/');
            metadata(imageNum).FileName = string(tmp{2});
        end


    end

end
