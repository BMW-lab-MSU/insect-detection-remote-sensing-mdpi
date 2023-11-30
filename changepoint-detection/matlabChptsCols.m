% SPDX-License-Identifier: BSD-3-Clause
%% Path setup
beehiveDataSetup;

%% Bee Image Iteration
tic
load(testingDataDir + filesep + "testingData.mat");

numImages = length(testingData);
testingResultsLabel = zeros(numImages,2);     % Image # | Insect Present 
testingResultsLabel(1:end,1) = (1:numImages);
testingResultData = cell(numImages,1);

testingRowLabelPredicted = cell(numImages,1);

% Training Image Iteration
parfor imageNum = 1:length(testingData)
    image = -1.*testingData{1,imageNum};
    rowsPredicted = zeros(1,size(image,1));

    validRows = zeros(1,size(image,1));
    % Row Validation
    for rowCheck = 1:size(image,1)
        if(range(image(rowCheck,:) > mean(image(rowCheck,:))))
            validRows(rowCheck) = 1;
        end
    end
    validIndeces = find(validRows);

    % Column Iteration
    beeCols = cell(1,size(image,2));
    for col = 1:size(image,2)
        tmpResults = findchangepts(image(:,col),'Statistic','mean','MinThreshold',.0025);
        if(~isempty(tmpResults))
            beeRows = tmpResults;
            beeRowsChecked = beeRows(ismember(beeRows,validIndeces));
            for rowIndex = 1:numel(beeRowsChecked)
                row = beeRowsChecked(rowIndex);
                if(image(row,col) > mean(image(row,:)))
                    beeCols{1,col} = tmpResults;
                    rowsPredicted(row) = 1;
                end
            end
        end
    end

    testingRowLabelPredicted{imageNum,1} = rowsPredicted;

    if(any(~cellfun(@isempty,beeCols)))
        testingResultData{imageNum} = beeCols;
    end

end

beeIndeces = ~cellfun(@isempty,testingResultData);
testingResultsLabel(beeIndeces,2) = 1;

% Saving Full Directory Structure
results = {testingResultsLabel,testingRowLabelPredicted,testingResultData,"Img Results | Row Results | Data"};

if ~exist(changepointResultsDir,'dir')
    mkdir(changepointResultsDir);
end
save(changepointResultsDir + filesep + "matlabChptsColsResults.mat","results",'-v7.3');
