function preprocess
% PREPROCESS threshold the data to remove reflection artifacts

% SPDX-License-Identifier: BSD-3-Clause

beehiveDataSetup;

%% Load in data
filenames = ["2022-06-combined", "2022-07-combined"];

for filename = filenames
    load(combinedDataDir + filesep + filename)
end

%% Threshold data to reduce PMT ringing
% PMT rigning manifests as data > 0 volts, so we can threshold all positive
% values to help reduce ringing. We threshold positive voltages to the mean of
% the row they are in, which should eliminate most of the ringing and make it
% blend in with the rest of the row. This doesn't reduce all ringing artifacts,
% but it helps.
% NOTE: this could be turned into a function later if we do more preprocessing and 
%       want to make this more modular.

for imageNum = 1:numel(juneData)
    for rowNum = 1:height(juneData{imageNum})
        rowMean = mean(juneData{imageNum}(rowNum,:));

        % Find the columns that have positive voltage values, if any
        positiveVoltageIndicator = juneData{imageNum}(rowNum,:) > 0;

        % Set all positive voltages equal to the row mean
        juneData{imageNum}(rowNum,positiveVoltageIndicator) = rowMean;
    end
end

for imageNum = 1:numel(julyData)
    for rowNum = 1:height(julyData{imageNum})
        rowMean = mean(julyData{imageNum}(rowNum,:));

        % Find the columns that have positive voltage values, if any
        positiveVoltageIndicator = julyData{imageNum}(rowNum,:) > 0;

        % Set all positive voltages equal to the row mean
        julyData{imageNum}(rowNum,positiveVoltageIndicator) = rowMean;
    end
end


%% Save data
if ~exist(preprocessedDataDir)
    mkdir(baseDataDir, "preprocessed");
end
save(preprocessedDataDir + filesep + "2022-06-preprocessed.mat", ...
    'juneData', 'juneRowLabels', 'juneRowConfidence', 'juneImgLabels', ...
    'juneMetadata', '-v7.3');
save(preprocessedDataDir + filesep + "2022-07-preprocessed.mat", ...
    'julyData', 'julyRowLabels', 'julyRowConfidence', 'julyImgLabels', ...
    'julyMetadata', '-v7.3');

end
