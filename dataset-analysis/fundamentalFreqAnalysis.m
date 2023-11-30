% SPDX-License-Identifier: BSD-3-Clause
% 1. Load CSV and create struct with image folder, image, column start and end
% 2. Load each folder and grab metadata
% 3. Index into adjusted_data_junecal.time with the stop column and start
% column and find the difference between the two.
beehiveDataSetup;

dates = ["2022-06-23" "2022-06-24" "2022-07-28" "2022-07-29"];
folderPrefix = "MSU-horticulture-farm-bees-";
imageNum0623 = ["122126" "135615" "141253" "144154" "145241"];
imageNum0624 = ["094752" "095001" "104012" "105017" "110409" "111746" "113017" "114343" "115816"];
imageNum0728 = ["112652" "120850" "123948" "124905" "131133" "133834" "135906" "141427" "143013" "144821"];
imageNum0729 = ["093945" "095958" "101924"];
scanNumbers = {imageNum0623, imageNum0624, imageNum0728, imageNum0729};
dataFilename = "adjusted_data_junecal_volts";

data = readtable(rawDataDir + filesep + "labels.csv");
inputCSV = table2struct(data);
indexCSV = 1;
countMaxCSV = numel(inputCSV);
beeCounter = 1;

for indexDay = 1:length(dates)
    date = dates(indexDay);
    scanNums = scanNumbers{indexDay};

    for indexScan = 1:length(scanNums)
        filePath = rawDataDir + filesep + date + filesep + folderPrefix + scanNums(indexScan);
        load(filePath + filesep + dataFilename);

        while(strcmp(folderPrefix+scanNums(indexScan),inputCSV(indexCSV).scanName))
            inputCSV(indexCSV).scanName

            image = adjusted_data_junecal(inputCSV(indexCSV).imageNum).data;

            % extract the bee rows out of the image
            startRow = inputCSV(indexCSV).startRow;
            endRow = inputCSV(indexCSV).endRow;
            beeData = mean(image(startRow:endRow,:),1);

            time = adjusted_data_junecal(inputCSV(indexCSV).imageNum).time;
            avgPrf = averagePRF(time);

            features = extractFreqDomainFeatures(beeData,avgPrf);

            startTime = adjusted_data_junecal(inputCSV(indexCSV).imageNum).time(inputCSV(indexCSV).startCol);
            endTime = adjusted_data_junecal(inputCSV(indexCSV).imageNum).time(inputCSV(indexCSV).endCol);
            time = endTime - startTime;

            inputCSV(indexCSV).transitTime = time;

            beeFundamentalFrequencies{beeCounter,1} = folderPrefix+scanNums(indexScan);
            beeFundamentalFrequencies{beeCounter,2} = features.HarmonicFreq1;
            beeCounter = beeCounter+1;
            if(indexCSV < countMaxCSV)
                indexCSV = indexCSV + 1;
            else
                break;
            end
        end

    end

end

save(datasetAnalysisResultsDir + filesep + "beeFundamentalFrequencies.mat","beeFundamentalFrequencies","-v7.3");