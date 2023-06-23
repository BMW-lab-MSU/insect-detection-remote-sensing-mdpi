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

% baseDir = "../bee-lidar-data\msu-bee-hives";
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
        image = -1.*images{3,1,imageNum};

        % Preprocessing
        image(image < 0) = 0;
        smoothdata(image,2,'movmean',3);

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
            directoryData{imageNum} = beeRows;
        end

    end

    beeIndeces = ~cellfun(@isempty,directoryData);
    directoryResults(beeIndeces,2) = 1;

    % Saving Full Directory Structure
    results = {directoryResults,directoryData,date+"-"+scanNums(scanNum),"Results | Data | Folder"};
    save(baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + "rowResultsOriginal_gfpop.mat","results");

end
end
runtime = toc;
save("rowOriginalRuntime_gfpop.mat","runtime")