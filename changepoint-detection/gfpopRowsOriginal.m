% gfpop rows with original images

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

% Training Image Iteration
parfor imageNum = 1:length(testingData)
    image = -1.*testingData{1,imageNum}

    % Row Iteration
    beeRows = cell(1,size(image,1));
    for row = 1:size(image,1)
        tmpResults = gfpop(image(row,:),beeGraph,"mean");
        if(any(tmpResults.states.contains("BEE")))
            if(tmpResults.parameters(tmpResults.states.contains("BEE"))) > 2*mean(image(row,:)) % Hard Target Verification
                beeRows{1,row} = tmpResults;
            end
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
save("../../results/changepoint-results/rowResultsOriginal_gfpop.mat","results",'-v7.3');

runtime = toc;
save("../../results/changepoint-results/rowSparseRuntime_gfpop.mat","runtime")