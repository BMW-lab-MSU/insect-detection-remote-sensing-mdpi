% gfpop rows with sparse coding

% Runs through the LiDAR images after sparse coding preprocessing. This
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

% baseDir = "../afrl-data/insect-lidar/msu-bee-hives";
baseDir = "../data/raw";
dates = ["2022-06-23" "2022-06-24" "2022-07-28" "2022-07-29"];
folderPrefix = "MSU-horticulture-farm-bees-";
imageNum0623 = ["122126" "135615" "141253" "144154" "145241"];
imageNum0624 = ["094752" "095001" "104012" "105017" "110409" "111746" "113017" "114343"];
imageNum0728 = ["112652" "120850" "123948" "124905" "131133" "133834" "135906" "141427" "143013" "144821"];
imageNum0729 = ["093945" "095958" "101924"];
scanNumbers = {imageNum0623, imageNum0624, imageNum0728, imageNum0729};
structName = "adjusted_data_junecal_volts";

% Folder Setup
for index = 1:length(dates)
date = dates(index);
scanNums = scanNumbers{index};
for scanNum = 1:length(scanNums)
imageDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + structName;
beeStruct = load(imageDirectory);
numImages = numel(beeStruct.adjusted_data_junecal);
directoryResults = zeros(numImages,2);     % Image # | Insect Present 
directoryResults(1:end,1) = (1:numImages);
directoryData = cell(numImages,1);

    % Image Iteration
    images = struct2cell(beeStruct.adjusted_data_junecal);
    parfor imageNum = 1:numImages
        image = -1.*images{3,1,imageNum}
        
        % Preprocessing
        image(image < 0) = 0;
        smoothdata(image,2,'movmean',3);

        % Row Iteration
        beeBoth = cell(2,size(image,1));
        for row = 1:size(image,1)
            tmpResultsRow = gfpop(image(row,:),beeGraph,"mean");
            if(any(tmpResultsRow.states.contains("BEE")))
                beeCols = tmpResultsRow.changepoints(tmpResultsRow.states == "BEE");
                if(~isempty(beeCols))
                    for beeColumns = 1:length(beeCols)
                        tmpResultsCol = gfpop(image(:,beeCols(beeColumns)),beeGraph,"mean");
                        if(any(tmpResultsCol.states.contains("BEE")))
                            beeBoth{1,row} = tmpResultsRow;
                            beeBoth{2,row} = tmpResultsCol;
                        end
                    end
                end
            end
        end

        if(any(~cellfun(@isempty,beeBoth)))
            directoryData{imageNum,1} = beeBoth;
        end

    end

    beeIndeces = ~cellfun(@isempty,directoryData);
    directoryResults(beeIndeces,2) = 1;

    % Saving Full Directory Structure
    results = {directoryResults,directoryData,date+"-"+scanNums(scanNum),"Results | Data | Folder"};
    save(baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + "bothResultsSparse_gfpop.mat","results");

end
end
runtime = toc;
save("bothSparseRuntime_gfpop.mat","runtime")