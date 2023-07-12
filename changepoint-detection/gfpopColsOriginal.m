% gfpop columns with original images

% Runs through the LiDAR images with verification after detecting
% changepoint.

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
load("../../data/testing/testingData.mat");

numImages = length(testingData);
testingResultsLabel = zeros(numImages,2);     % Image # | Insect Present 
testingResultsLabel(1:end,1) = (1:numImages);
testingResultData = cell(numImages,1);

testingRowLabelPredicted = cell(numImages,1);

% Training Image Iteration
parfor imageNum = 1:length(testingData)
    image = -1.*testingData{1,imageNum}
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
        tmpResults = gfpop(image(:,col),beeGraph,"mean");
        if(any(tmpResults.states.contains("BEE")))
            beeRows = tmpResults.changepoints(tmpResults.states == "BEE");
            beeRowsChecked = beeRows(ismember(beeRows,validIndeces));
            counter = 1;
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
save("../../results/changepoint-results/colResultsOriginal_gfpop.mat","results",'-v7.3');