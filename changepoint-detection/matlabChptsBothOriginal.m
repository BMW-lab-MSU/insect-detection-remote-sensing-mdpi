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

    % Row Iteration
    beeBoth = cell(1,size(image,1));
    for row = 1:size(image,1)
        if(range(image(row,:) > mean(image(row,:))))
            tmpResultsRow = findchangepts(image(row,:),'Statistic','mean','MinThreshold',.0025);
            if(~isempty(tmpResultsRow))
                if(numel(tmpResultsRow) < 5)
                    columnsFromRow = tmpResultsRow;
                    for colIndex = 1:numel(columnsFromRow)
                        col = columnsFromRow(colIndex);
                        tmpResultsCol = findchangepts(image(:,col),'Statistic','mean','MinThreshold',.005);
                        if(~isempty(tmpResultsCol))
                            rowsFromCol = tmpResultsCol;
                            for rowIndex = 1:numel(rowsFromCol)
                                tmpRow = rowsFromCol(rowIndex);
                                if(norm([row col] - [tmpRow col]) < 4)
                                    beeBoth{row} = {tmpResultsRow,tmpResultsCol};
                                end
                            end
                        end
                    end
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
save("../../results/changepoint-results/bothResultsOriginal_matlab.mat","results",'-v7.3');

runtime = toc;
save("../../results/changepoint-results/runtimes/bothOriginalRuntime_matlab.mat","runtime")