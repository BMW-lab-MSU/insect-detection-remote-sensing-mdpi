%% Path setup
beehiveDataSetup;

%% Graph Generation

% Parameters
B1 = .005;
B2 = .005;

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
    beeBoth = cell(1,size(image,1));
    for row = 1:size(image,1)
        if(range(image(row,:) > mean(image(row,:))))
            tmpResultsRow = gfpop(image(row,:),beeGraph,"mean");
            if(any(tmpResultsRow.states.contains("BEE")))
                if(numel(tmpResultsRow.changepoints(tmpResultsRow.states == "BEE")) < 5)
                    columnsFromRow = tmpResultsRow.changepoints(tmpResultsRow.states == "BEE");
                    for colIndex = 1:numel(columnsFromRow)
                        col = columnsFromRow(colIndex);
                        tmpResultsCol = gfpop(image(:,col),beeGraph,"mean");
                        if(any(tmpResultsCol.states.contains("BEE")))
                            rowsFromCol = tmpResultsCol.changepoints(tmpResultsCol.states == "BEE");
                            for rowIndex = 1:numel(rowsFromCol)
                                tmpRow = rowsFromCol(rowIndex);
                                if(norm(double([row col]) - double([tmpRow col])) < 4)
                                    beeBoth{row} = {tmpResultsRow,tmpResultsCol};
                                    rowsPredicted(row) = 1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    testingRowLabelPredicted{imageNum,1} = rowsPredicted;

    if(any(~cellfun(@isempty,beeBoth)))
        testingResultData{imageNum,1} = beeBoth;
    end

end

beeIndeces = ~cellfun(@isempty,testingResultData);
testingResultsLabel(beeIndeces,2) = 1;

% Saving Full Directory Structure
results = {testingResultsLabel,testingRowLabelPredicted,testingResultData,"Img Results | Row Results | Data"};

if ~exist(changepointResultsDir,'dir')
    mkdir(changepointResultsDir);
end
save(changepointResultsDir + filesep + "gfpopBothResults.mat","results",'-v7.3');
