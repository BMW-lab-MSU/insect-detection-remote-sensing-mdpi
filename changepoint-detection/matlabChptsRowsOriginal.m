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

    % Row Iteration
    beeRows = cell(1,size(image,1));
    for row = 1:size(image,1)
        if(range(image(row,:) > mean(image(row,:))))
            tmpResults = findchangepts(image(row,:),'Statistic','mean','MinThreshold',.0025);
            if(~isempty(tmpResults))
                if(numel(tmpResults) < 5)
                    columns = tmpResults
                    if(any(image(row,tmpResults:tmpResults) > mean(image(row,:))))
                        beeRows{1,row} = tmpResults;
                        rowsPredicted(row) = 1;
                    end
                end
            end
        end
    end

    testingRowLabelPredicted{imageNum,1} = rowsPredicted;

    if(any(~cellfun(@isempty,beeRows)))
        testingResultData{imageNum} = beeRows;
    end

end

beeIndeces = ~cellfun(@isempty,testingResultData);
testingResultsLabel(beeIndeces,2) = 1;

% Saving Full Directory Structure
results = {testingResultsLabel,testingRowLabelPredicted,testingResultData,"Img Results | Row Results | Data"};
save(changepointResultsDir + filesep + "rowResultsOriginal_matlab.mat","results",'-v7.3');