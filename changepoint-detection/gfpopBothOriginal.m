%% Graph Generation

% Parameters
B1 = .01;
B2 = .01;

% Edges
edge1 = gfpopEdge("air","inc_to_bee","up",penalty=B1);
edge2 = gfpopEdge("inc_to_bee","inc_to_bee","up");
edge3 = gfpopEdge("inc_to_bee","BEE","up");
edge4 = gfpopEdge("BEE","dec_from_bee","down",penalty=B2);
edge5 = gfpopEdge("dec_from_bee","dec_from_bee","down");
edge6 = gfpopEdge("dec_from_bee","air","down");

% Graph
beeGraph = gfpopGraph(edges=[edge1 edge2 edge3 edge4 edge5 edge6],allNullEdges=true);

%% Bee Image Iteration
tic
load("../../data/testing/testingData.mat");

numImages = length(testingData);
testingResultsLabel = zeros(numImages,2);     % Image # | Insect Present 
testingResultsLabel(1:end,1) = (1:numImages);
testingResultData = cell(numImages,1);

% Training Image Iteration
parfor imageNum = 1:length(testingData)
    image = -1.*testingData{1,imageNum};

    % Row Iteration
    beeBoth = cell(1,size(image,1));
    for row = 1:size(image,1)
        tmpResultsRow = gfpop(image(row,:),beeGraph,"mean");
        if(any(tmpResultsRow.parameters(tmpResultsRow.states.contains("BEE"))) < 2*mean(image,'all'))% Hard Target Verification
            if(any(tmpResultsRow.states.contains("BEE")))
                columns = tmpResultsRow.changepoints(tmpResultsRow.states == "BEE");
                confirmedColumns = zeros(1,length(columns));
                for col = 1:length(columns)
                    testCol = columns(col);
                    colRanges = testCol-2:testCol+2;
                    colRanges(colRanges < 1) = 1;
                    colRanges(colRanges > 1024) = 1024;
                    for column = 1:length(colRanges)
                        testColumn = colRanges(column);
                        tmpResultsCol = gfpop(image(:,testColumn),beeGraph,"mean");
                        if(any(tmpResultsCol.states.contains("BEE")))
                            if(abs(row - tmpResultsCol.changepoints(tmpResultsCol.states == "BEE")) < 5)
                                confirmedColumns(col) = 1;
                            end
                        end
                    end
                end
                beeBoth{row} = confirmedColumns;
            end
        end
        % tmpResultsRow = gfpop(image(row,:),beeGraph,"mean");
        % if(any(tmpResultsRow.parameters(tmpResultsRow.states.contains("BEE"))) > 1.2*mean(image(row,:)))% Hard Target Verification
        %     if(any(tmpResultsRow.states.contains("BEE")))
        %         beeCols = tmpResultsRow.changepoints(tmpResultsRow.states == "BEE");
        %         if(~isempty(beeCols))
        %             for beeColumns = 1:length(beeCols)
        %                 tmpResultsCol = gfpop(image(:,beeCols(beeColumns)),beeGraph,"mean");
        %                 if(any(tmpResultsCol.states.contains("BEE")))
        %                     if(any(abs(tmpResultsCol.changepoints(tmpResultsCol.states == "BEE") - row) < 4))
        %                         beeBoth{1,row} = tmpResultsRow;
        %                         beeBoth{2,row} = tmpResultsCol;
        %                     end
        %                 end
        %             end
        %         end
        %     end
        % end
    end

    if(any(~cellfun(@isempty,beeBoth)))
        testingResultData{imageNum,1} = beeBoth;
    end

end

beeIndeces = ~cellfun(@isempty,testingResultData);
testingResultsLabel(beeIndeces,2) = 1;

% Saving Full Directory Structure
results = {testingResultsLabel,testingResultData,"Results | Data"};
save("../../results/changepoint-results/bothResultsOriginal_gfpop.mat","results",'-v7.3');

runtime = toc;
save("../../results/changepoint-results/runtimes/bothOriginalRuntime_gfpop.mat","runtime")