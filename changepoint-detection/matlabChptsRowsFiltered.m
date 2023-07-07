%% Bee Image Iteration
tic
load("../../data/testing/testingDataFiltered.mat");

numImages = length(testingData);
testingResultsLabel = zeros(numImages,2);     % Image # | Insect Present 
testingResultsLabel(1:end,1) = (1:numImages);
testingResultData = cell(numImages,1);

% Training Image Iteration
parfor imageNum = 1:length(testingData)
    image = -1.*testingData{1,imageNum}

    % Row Iteration
    beeRows = cell(1,size(image,1));
    for row = 1:size(image,1)
        tmpResults = findchangepts(image(row,:),'Statistic','mean','MinThreshold',.01);
        if(~isempty(tmpResults))
            beeRows{1,row} = tmpResults;
        end
    end

    if(any(~cellfun(@isempty,beeRows)))
        testingResultData{imageNum} = beeRows;
    end

end

beeIndeces = ~cellfun(@isempty,testingResultData);
testingResultsLabel(beeIndeces,2) = 1;

% Saving Full Directory Structure
results = {testingResultsLabel,testingResultData,"Results | Data"};
save("../../results/changepoint-results/rowResultsFiltered_matlab.mat","results",'-v7.3');

runtime = toc;
save("../../results/changepoint-results/runtimes/rowFilteredRuntime_matlab.mat","runtime")