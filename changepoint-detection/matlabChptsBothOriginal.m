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
    beeBoth = cell(2,size(image,1));
    for row = 1:size(image,1)
        tmpResultsRow = findchangepts(image(row,:),'Statistic','mean','MinThreshold',.005);
        if(~isempty(tmpResultsRow))
            if(any(mean(image(row,:))) < 10*mean(image,'all'))
                columns = tmpResultsRow;
                confirmedColumns = zeros(1,length(columns));
                for col = 1:length(columns)
                    testCol = columns(col);
                    colRanges = testCol-2:testCol+2;
                    colRanges(colRanges < 1) = 1;
                    colRanges(colRanges > 1024) = 1024;
                    for column = 1:length(colRanges)
                        testColumn = colRanges(column);
                        tmpResultsCol = findchangepts(image(:,testColumn),'Statistic','mean','MinThreshold',.005);
                        if(~isempty(tmpResultsCol))
                            if(any(abs(row - tmpResultsCol) < 5))
                                confirmedColumns(col) = 1;
                            end
                        end
                    end
                end
                beeBoth{row} = confirmedColumns;
            end

            % if(any(mean(image(tmpResultsRow,:))) < 5*mean(image,'all')) % Hard Target Verification
            %     columns = tmpResultsRow:tmpResultsRow+10;
            % 
            %     for col = 1:length(columns)
            %         testCol = columns(col);
            %         tmpResultsCol = findchangepts(image(row,tmpResultsRow),'Statistic','mean','MinThreshold',.005);
            %         if(~isempty(tmpResultsCol))
            %             if(abs(row - tmpResultsCol) < 5)
            %                 confirmedColumns(col) = 1;
            %             end
            %         end
            %     end
            %     beeBoth{row} = confirmedColumns;
            % end
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