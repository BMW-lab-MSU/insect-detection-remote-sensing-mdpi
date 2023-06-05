% gfpop columns with sparse coding

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

baseDir = "../afrl-data/insect-lidar/msu-bee-hives";
dates = ["2022-06-23" "2022-06-24" "2022-07-28" "2022-07-29"];
folderPrefix = "MSU-horticulture-farm-bees-";
imageNum0623 = ["121320" "121708" "121757" "135615" "141253" "144154" "145241"];
imageNum0624 = ["094752" "095001" "104012" "105017" "110409" "111746" "113017" "114343"];
imageNum0728 = ["112652" "120850" "123948" "124905" "131133" "133834" "135906" "141427" "143013" "144821"];
imageNum0729 = ["090758" "093945" "095958" "101924"];
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
directoryResults = [];

    % Image Iteration
    parfor imageNum = 1:numImages

        image = beeStruct.adjusted_data_junecal(imageNum).data;
        beeColumns = [];
        % Column Iteration
        for col = 1:size(image,2)
            tmpResults = gfpop(image(:,col),beeGraph,"mean");
            if(any(tmpResults.states.contains("BEE")))
                beeColumns = [beeColumns tmpResults];
            end
        end

        if(length(beeColumns) > 0)
            outputStructure = struct("columnData",beeColumns,"image",imageNum);
            directoryResults =  [directoryResults outputStructure];
        else
            outputStructure = struct("columnData",nan,"image",nan);
            directoryResults = [directoryResults outputStructure];
        end

    end

    % Saving Full Directory Structure
    results = {directoryResults,date+"-"+scanNums(scanNum)};
    save(baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + "columnResults.mat","results");

end
end
toc
save("columnSparseRuntime.mat","toc")

%% Insect Image Iteration