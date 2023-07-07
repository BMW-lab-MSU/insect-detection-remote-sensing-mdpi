load("../../data/training/trainingDataFiltered.mat","trainingData","trainingImgLabels");
trainingDataFiltered = trainingData;
trainingImgLabelsFiltered = trainingImgLabels;
load("../../data/training/trainingData.mat","trainingData","trainingImgLabels");
%% Graph Generation

% Parameters
B1 = .001;
B2 = .001;

% Edges
edge1 = gfpopEdge("air","inc_to_bee","up",penalty=B1);
edge2 = gfpopEdge("inc_to_bee","inc_to_bee","up");
edge3 = gfpopEdge("inc_to_bee","BEE","up");
edge4 = gfpopEdge("BEE","dec_from_bee","down",penalty=B2);
edge5 = gfpopEdge("dec_from_bee","dec_from_bee","down");
edge6 = gfpopEdge("dec_from_bee","air","down");

% Graph
beeGraph = gfpopGraph(edges=[edge1 edge2 edge3 edge4 edge5 edge6],allNullEdges=true);

%%
% img = 1;
% figure(1);
% subplot(211); imagesc(-1.*trainingData{img},[-0.02 0.06]); title("Original");
% subplot(212); imagesc(-1.*trainingDataFiltered{img},[-0.02 0.06]); title("Filtered");

%%
testImg = -1.*trainingData{2756};
rowResults = cell(1,178);
confirmedBees = {};
for row = 1:size(testImg,1)
    tmpResultsRow = gfpop(testImg(row,:),beeGraph,"mean");
        if(any(tmpResultsRow.parameters(tmpResultsRow.states.contains("BEE"))) > 1.2*mean(testImg(row,:)))% Hard Target Verification
            if(any(tmpResultsRow.states.contains("BEE")))
                columns = tmpResultsRow.changepoints(tmpResultsRow.states == "BEE");
                confirmedColumns = zeros(1,length(columns));
                for col = 1:length(columns)
                    testCol = columns(col);
                    colRanges = testCol-2:testCol+2;
                    colRanges(colRanges < 0) = 1;
                    colRanges(colRanges > 1024) = 1024;
                    for column = 1:length(colRanges)
                        testColumn = colRanges(column);
                        tmpResultsCol = gfpop(testImg(:,testColumn),beeGraph,"mean");
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
end
% figure(1);
% imagesc(testImg); hold on;
% scatter(confirmedBees{1}(1),confirmedBees{1}(2),'rx');

%%
% row = 1;
% figure(2);
% subplot(211); plot(-1.*trainingData{img}(row,:)); title('Original');
% subplot(212); plot(-1.*trainingDataFiltered{img}(row,:)); title('Filtered');