%% Bee Image Iteration
tic

numImages = length(testingData);
testingResultsLabel = zeros(numImages,2);     % Image # | Insect Present 
testingResultsLabel(1:end,1) = (1:numImages);
testingResultData = cell(numImages,1);

% Training Image Iteration
parfor imageNum = 1:length(testingData)
    image = -1.*testingData{1,imageNum};

    % Preprocessing
    image(image < 0) = 0;
    smoothdata(image,1,'movmean',3);

    % Column Iteration
    beeCols = cell(1,size(image,2));
    for col = 1:size(image,2)
        tmpResults = findchangepts(image(:,col),'Statistic','mean','MinThreshold',.005);
        if(~isempty(tmpResults))
            beeCols{1,col} = tmpResults;
        end
    end

    if(any(~cellfun(@isempty,beeCols)))
        directoryData{imageNum} = beeCols;
    end

end

beeIndeces = ~cellfun(@isempty,testingResultData);
testingResultsLabel(beeIndeces,2) = 1;

% Saving Full Directory Structure
results = {testingResultsLabel,testingResultData,"Results | Data"};
save("../../results/changepoint-results/colResultsSparse_matlab.mat","results");

runtime = toc;
save("../../results/changepoint-results/colSparseRuntime_matlab.mat","runtime")