% matlab findchangepts rows with original images

% Runs through the LiDAR images with verification after detecting
% changepoint.

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
            tmpResults = findchangepts(image(row,:),'Statistic','mean','MinThreshold',.005);
            if(~isempty(tmpResults))
                if(any(image(row,tmpResults)) > 2*mean(image(row,:))) % Hard Target Verification
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
    save(baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + "rowResultsOriginal_matlab.mat","results");

end
end
runtime = toc;
save("rowOriginalRuntime_matlab.mat","runtime")