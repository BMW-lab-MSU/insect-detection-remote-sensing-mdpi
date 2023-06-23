%% Bee Image Iteration
tic
load("../../data/testing/testingData.mat");

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
    beeBoth = cell(2,size(image,1));
    for row = 1:size(image,1)
        tmpResultsRow = findchangepts(image(row,:),'Statistic','mean','MinThreshold',.005);
        if(~isempty(tmpResultsRow))
            tmpResultsCol = findchangepts(image(row,tmpResultsRow),'Statistic','mean','MinThreshold',.005);
            if(~isempty(tmpResultsCol))
                if(any(tmpResultsCol == row))
                    beeBoth{1,row} = tmpResultsRow;
                    beeBoth{2,row} = tmpResultsCol;
                end
            end
        end
    end

    if(any(~cellfun(@isempty,beeBoth)))
        testingResultData{imageNum,1} = beeBoth;
    end

end

beeIndeces = ~cellfun(@isempty,testingResultData);
testingResultsLabel(beeIndeces,2) = 1;

% Saving Full Directory Structure
results = {testingResultsLabel,testingResultData,"Results | Data"};
save("../../results/changepoint-results/bothResultsSparse_matlab.mat","results");

runtime = toc;
save("../../results/changepoint-results/bothSparseRuntime_matlab.mat","runtime")