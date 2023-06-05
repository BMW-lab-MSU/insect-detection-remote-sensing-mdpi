% SPDX-License-Identifier: BSD-3-Clause
N_ROWS = 178;
N_COLS = 1024;

DATA_FILENAME = "adjusted_data_junecal_volts.mat";
LABELS_FILENAME = "labels.mat";

days = ["2022-06-23", "2022-06-24"];

scansIds = cell(numel(days), 1);

% Get all the folders that contain a scan
for i = 1:numel(days)
    % Grab the directories under the "day" folder
    tmp = string({dir(string(rawDataDir) + filesep + days(i)).name});

    % Find the directories that contain scans (which contain a timestamp),
    % e.g. "RedLight-225413"
    match = regexp(tmp, '\w+-\d{6}');
    scanIdx = cellfun(@(c) ~isempty(c), match);
    scanIds{i} = tmp(scanIdx);
end

nScans = numel([scanIds{:}]);

scans = struct('Day', string(), 'Id', string(), 'Data', cell(nScans, 1), ...
    'Labels', cell(nScans, 1), 'ImageLabels', cell(nScans, 1), ...
    'ScanLabel', false, 'Pan', cell(nScans, 1), ...
    'Tilt', cell(nScans, 1), 'Range', cell(nScans, 1), 'Time', cell(nScans, 1));

if exist('ProgressBar')
    progbar1 = ProgressBar(nScans, 'UpdateRate', 1);
end

scanNum = 1;
for i = 1:numel(days)
    for j = 1:numel(scanIds{i})
        scanId = scanIds{i}(j);

        % Load data
        load(string(rawDataDir) + filesep + days(i) + filesep + scanId ...
            + filesep + DATA_FILENAME);
        
        % Load labels
        load(string(rawDataDir) + filesep + days(i) + filesep + scanId ...
            + filesep + LABELS_FILENAME);


        scans(scanNum).Day = days(i);
        scans(scanNum).Id = scanIds{i}(j);

        % Convert data to single-precsion to reduce memory usage
        scans(scanNum).Data = cellfun(@(c) single(c), ...
            {adjusted_data_junecal.data}', ...
            'UniformOutput', false);


        scans(scanNum).Labels = rowLabels;
        scans(scanNum).ImageLabels = imageLabels;

        % Create labels for entire runs
        scans(scanNum).ScanLabel = any(scans(scanNum).ImageLabels);

        % Grab metadata
        scans(scanNum).Tilt = [adjusted_data_junecal.tilt]';
        scans(scanNum).Pan = [adjusted_data_junecal.pan]';
        scans(scanNum).Time = {adjusted_data_junecal.time}';
        scans(scanNum).Range = {adjusted_data_junecal.range}';

        scanNum = scanNum + 1;

        if exist('ProgressBar')
            progbar1([],[],[])
        end
    end
end

if ~exist(combinedDataDir)
    mkdir(combinedDataDir)
end
save([combinedDataDir filesep 'scans'], 'scans', '-v7.3');
