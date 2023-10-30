%% Path setup
beehiveDataSetup;

%% Load data
load(trainingDataDir + filesep + "trainingDataFiltered.mat","trainingData","trainingImgLabels");
trainingDataFiltered = trainingData;
trainingImgLabelsFiltered = trainingImgLabels;
load(trainingDataDir + filesep + "trainingData.mat","trainingData","trainingImgLabels");

%% Graph Generation

% Parameters
B1 = .0025;
B2 = .0025;

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

imgNum = 1996;
testImg = -1.*trainingData{imgNum};
testImg(testImg < 0) = mean(testImg,"all");
figure(1); clf; imagesc(testImg); hold on; drawnow;
testImg = movmean(testImg,2,1);
for row = 1:size(testImg,1)
    if(range(testImg(row,:) > 2*mean(testImg(row,:))))
        tmpResultsMatlab = findchangepts(testImg(row,:),'Statistic','mean','MinThreshold',.0025);
        if(~isempty(tmpResultsMatlab))
            if(numel(tmpResultsMatlab) < 5)
                if(any(testImg(row,tmpResultsMatlab:tmpResultsMatlab+10) > mean(testImg(row,:))))
                    scatter(tmpResultsMatlab,row,'rx');
                end
            end
        end
    
        tmpResultsgfpop = gfpop(testImg(row,:),beeGraph,"mean");
        if(any(tmpResultsgfpop.states.contains("BEE")))
            if(numel(tmpResultsgfpop.changepoints(tmpResultsgfpop.states == "BEE")) < 5)
                if(any(tmpResultsgfpop.parameters(tmpResultsgfpop.states == "BEE") > mean(testImg(row,:))))
                    scatter(tmpResultsgfpop.changepoints(tmpResultsgfpop.states == "BEE"),row,'ro');
                end
            end
        end
    end
end

testImg = -1.*trainingData{imgNum};
testImg(testImg < 0) = mean(testImg,"all");
testImg = movmean(testImg,2,2);

beeRowsgfpop = zeros(size(testImg,1),1);
beeRowsMatlab = zeros(size(testImg,1),1);

for col = 1:size(testImg,2)
        tmpResultsMatlab = findchangepts(testImg(:,col),'Statistic','mean','MinThreshold',.0025);
        if(~isempty(tmpResultsMatlab))
            checkedRows ={};
            counter = 1;
            for rowIndex = 1:numel(tmpResultsMatlab)
                row = tmpResultsMatlab(rowIndex);
                if(range(testImg(row,:) > 2*mean(testImg(row,:))))
                    if(testImg(row,col) > mean(testImg(row,:)))
                        % scatter(col,row,'gx');
                        checkedRows{counter} = row;
                        counter = counter + 1;
                    end
                end
            end
        end
        beeRowsMatlab(cell2mat(checkedRows)) =  beeRowsMatlab(cell2mat(checkedRows)) + 1;
    
        tmpResultsgfpop = gfpop(testImg(:,col),beeGraph,"mean");
        if(any(tmpResultsgfpop.states.contains("BEE")))
            checkedRows ={};
            counter = 1;
            beeRowsTmp = tmpResultsgfpop.changepoints(tmpResultsgfpop.states == "BEE");
            for rowIndex = 1:numel(beeRowsTmp)
                row = beeRowsTmp(rowIndex);
                if(range(testImg(row,:) > 2*mean(testImg(row,:))))
                    if(testImg(row,col) > mean(testImg(row,:)))
                        % scatter(col,row,'go');
                        checkedRows{counter} = row;
                        counter = counter + 1;
                    end
                end
            end
        end
        beeRowsgfpop(cell2mat(checkedRows)) = beeRowsgfpop(cell2mat(checkedRows)) + 1;


end

beeRowsgfpop(beeRowsgfpop > 256) = 0;
gfpoprows = find(beeRowsgfpop)
beeRowsMatlab(beeRowsMatlab > 256) = 0;
matlabrows = find(beeRowsMatlab)