function [data, rowLabels, rowConfidence, imgLabels, metadata] = combineData(dates, folderPrefix, folderTimestamps, rawDataDir)
% combineData combine data from individual folders into one mat file.
%
% Data are organized in the following folder hiearchy:
% ├── yyyy-mm-dd
% │   ├── prefix-hhmmss
% │   ├── prefix-hhmmss
% │   └── prefix-hhmmss
% ├── yyyy-mm-dd
% │   ├── prefix-hhmmss
% │   ├── prefix-hhmmss
% │   └── prefix-hhmmss
% 
% Where prefix is the folder prefix (e.g., description of the location
% or project). hhmmss is a 24-hour ISO-format timestamp indicating when the
% data collection run started. Each prefix-timestamp folder contains the
% data files: individual mat files for each image, and an adjusted_data file
% that contains all the individual images, metdata, etc. after some
% preprocessing. The adjusted_data file is what gets used in this function.
%
% [data,rowLabels,rowConfidence,imgLabels,metadata] = ...
%   combineData(dates,folderPrefix,folderTimestamps,rawDataDir) 
%
% Inputs:
%   - dates (string): Vector of dates corresponding to the folder names that
%       will be combined.
%   - folderPrefix (string): Prefix of the folders.
%   - folderTimestamps (string): Vector of timestamps corresponding to the
%       folder names that will be combined.
%   - rawDataDir (string): Name of the top-level folder that contains the data.
%
% Outputs:
%   - data: Cell array containing all of the data. Each cell contains an image.
%   - rowLabels: Cell array containing the row labels. Each cell corresponds to
%       one image.
%   - rowConfidence: Cell array containing the confidence raings. Each cell
%       corresponds to one image.
%   - imgLabels: Array of ground truth image labels: 1 indicates that the image
%       contains one or more insects.
%   - metadata: Struct containing metadata for each image. Metadata includes
%       the day, folder name, pan angle, tilt angle, range bins (in meters),
%       and the timestamps for each pulse in the image.

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
