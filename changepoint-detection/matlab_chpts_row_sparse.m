%% Bee Image Iteration
tic

numImages = length(testingData);
testingResultsLabel = zeros(numImages,2);     % Image # | Insect Present 
testingResultsLabel(1:end,1) = (1:numImages);
testingResultData = cell(numImages,1);

% Training Image Iteration
parfor imageNum = 1:length(testingData)
    image = -1.*testingData{1,imageNum}
    
    % Preprocessing
    image(image < 0) = 0;
    smoothdata(image,2,'movmean',3);

    % Row Iteration
    beeRows = cell(1,size(image,1));
    for row = 1:size(image,1)
        tmpResults = findchangepts(image(row,:),'Statistic','mean','MinThreshold',.005);
        if(~isempty(tmpResults))
            if(any(image(row,tmpResults)) > 2*mean(image(row,:))) % Hard Target Verification
                beeRows{1,row} = tmpResults;
            end
        end
    end

    if(any(~cellfun(@isempty,beeRows)))
        directoryData{imageNum} = beeRows;
    end

end

beeIndeces = ~cellfun(@isempty,testingResultData);
testingResultsLabel(beeIndeces,2) = 1;

% Saving Full Directory Structure
results = {testingResultsLabel,testingResultData,"Results | Data"};
save("../../results/changepoint-results/rowResultsSparse_matlab.mat","results");

runtime = toc;
save("../../results/changepoint-results/rowSparseRuntime_matlab.mat","runtime")