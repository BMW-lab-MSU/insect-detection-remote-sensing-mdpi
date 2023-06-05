% SPDX-License-Identifier: BSD-3-Clause
N_ROWS = 178;
N_COLS = 1024;

days = ["2020-09-16", "2020-09-17", "2020-09-18", "2020-09-20"];

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
            + filesep + "adjusted_data_decembercal");
        
        % Load events/labels
        load(string(rawDataDir) + filesep + days(i) + filesep + "events" + filesep ...
            + "fftcheck");


        scans(scanNum).Day = days(i);
        scans(scanNum).Id = scanIds{i}(j);

        % Convert data to single-precsion to reduce memory usage
        scans(scanNum).Data = cellfun(@(c) single(c), ...
            {adjusted_data_decembercal.normalized_data}', ...
            'UniformOutput', false);

        % Create label vectors
        % There are two types of labels: "definitely" insects and "maybe" insects;
        % these labels are combined together into a binary "insect/not-insect" label,
        % but we also keep fields for both label types for convenience when looking at
        % results (e.g. to see if the false positives were "definitely" or "maybe" insects).
        insects = createLabelsHyalite(fftcheck.insects, adjusted_data_decembercal);
        maybeInsects = createLabelsHyalite(fftcheck.maybe_insects, adjusted_data_decembercal);

        scans(scanNum).InsectLabels = insects;
        scans(scanNum).MaybeInsectLabels = maybeInsects;
        scans(scanNum).Labels = cellfun(@(c1, c2) or(c1, c2), insects, maybeInsects, 'UniformOutput', false);

        % Create labels for entire images
        scans(scanNum).InsectImageLabels = cellfun(@(c) any(c), insects);
        scans(scanNum).MaybeInsectImageLabels = cellfun(@(c) any(c), maybeInsects);
        scans(scanNum).ImageLabels = cellfun(@(c) any(c), scans(scanNum).Labels);

        % Create labels for entire scans
        scans(scanNum).InsectScanLabel = any(scans(scanNum).InsectImageLabels);
        scans(scanNum).MaybeInsectScanLabel = any(scans(scanNum).MaybeInsectImageLabels);
        scans(scanNum).ScanLabel = any(scans(scanNum).ImageLabels);

        % Grab metadata
        scans(scanNum).Tilt = [adjusted_data_decembercal.tilt]';
        scans(scanNum).Pan = [adjusted_data_decembercal.pan]';
        scans(scanNum).Time = {adjusted_data_decembercal.time}';
        scans(scanNum).Range = {adjusted_data_decembercal.range}';

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
