% 1. Load CSV and create struct with image folder, image, column start and end
% 2. Load each folder and grab metadata
% 3. Index into adjusted_data_junecal.time with the stop column and start
% column and find the difference between the two.
baseDir = "../../data/raw";
dates = ["2022-06-23" "2022-06-24" "2022-07-28" "2022-07-29"];
folderPrefix = "MSU-horticulture-farm-bees-";
imageNum0623 = ["122126" "135615" "141253" "144154" "145241"];
imageNum0624 = ["094752" "095001" "104012" "105017" "110409" "111746" "113017" "114343" "115816"];
imageNum0728 = ["112652" "120850" "123948" "124905" "131133" "133834" "135906" "141427" "143013" "144821"];
imageNum0729 = ["093945" "095958" "101924"];
scanNumbers = {imageNum0623, imageNum0624, imageNum0728, imageNum0729};
dataFilename = "adjusted_data_junecal_volts";

data = readtable("../../data/raw/labels.csv");
inputCSV = table2struct(data);
indexCSV = 1;
countMaxCSV = numel(inputCSV);
beeCounter = 1;

for indexDay = 1:length(dates)
    date = dates(indexDay);
    scanNums = scanNumbers{indexDay};

    for indexScan = 1:length(scanNums)-1
        filePath = baseDir + filesep + date + filesep + folderPrefix + scanNums(indexScan);
        load(filePath + filesep + dataFilename);

        while(strcmp(folderPrefix+scanNums(indexScan),inputCSV(indexCSV).scanName))
            inputCSV(indexCSV).scanName
            startTime = adjusted_data_junecal(inputCSV(indexCSV).imageNum).time(inputCSV(indexCSV).startCol);
            endTime = adjusted_data_junecal(inputCSV(indexCSV).imageNum).time(inputCSV(indexCSV).endCol);
            time = endTime - startTime;
            beeTransitTimes{beeCounter,1} = folderPrefix+scanNums(indexScan);
            beeTransitTimes{beeCounter,2} = time;
            beeCounter = beeCounter+1;
            indexCSV = indexCSV + 1;
        end

    end

end

save("beeTransitTimes.mat","beeTransitTimes","-v7.3");