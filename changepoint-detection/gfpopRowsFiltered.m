% gfpop rows with Filtered coding

% Runs through the LiDAR images after Filtered coding preprocessing. This
% means there is less verification of the changepoints since in theory the
% hard targets that cause all of the issues have been removed.

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
load("../../data/testing/testingDifferenceImages.mat");

numImages = length(testingDifferenceImages);
testingResultsLabel = zeros(numImages,2);     % Image # | Insect Present 
testingResultsLabel(1:end,1) = (1:numImages);
testingResultData = cell(numImages,1);

% Training Image Iteration
parfor imageNum = 1:length(testingDifferenceImages)
    image = -1.*testingDifferenceImages{1,imageNum}
    
    % Row Iteration
    beeRows = cell(1,size(image,1));
    for row = 1:size(image,1)
        tmpResults = gfpop(image(row,:),beeGraph,"mean");
        if(any(tmpResults.states.contains("BEE")))
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
save("../../results/changepoint-results/rowResultsFiltered_gfpop.mat","results",'-v7.3');

runtime = toc;
save("../../results/changepoint-results/rowFilteredRuntime_gfpop.mat","runtime")