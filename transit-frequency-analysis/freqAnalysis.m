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
beeFrequencies = cell(1,numel(inputCSV));
beeCounter = 1;

for indexDay = 1:length(dates)
    date = dates(indexDay);
    scanNums = scanNumbers{indexDay};

    for indexScan = 1:length(scanNums)
        filePath = baseDir + filesep + date + filesep + folderPrefix + scanNums(indexScan);
        load(filePath + filesep + dataFilename);

        while(strcmp(folderPrefix+scanNums(indexScan),inputCSV(indexCSV).scanName))
            
            for imageNum = 1:numel(adjusted_data_junecal)
                while(imageNum == inputCSV(indexCSV).imageNum)
                    image = adjusted_data_junecal(imageNum).data;
                    FS = averagePRF(adjusted_data_junecal(imageNum).time);
                    image = bandpassFilter(image,10,[50 1200],FS);
                    beeRows = inputCSV(indexCSV).startRow:inputCSV(indexCSV).endRow;
                    row = sum(vertcat(image(beeRows,:)));
                    fftResult = abs(fft(row)).^2;
                    fftPositive = fftResult(1:end/2);
                    harmonicIndex = estimateFundamentalFreq(fftPositive);
                    harmonic = (FS/1024)*harmonicIndex;
                    beeFrequencies{indexCSV} = harmonic;
                    inputCSV(indexCSV).beeFreqFiltered = harmonic;
                    if(indexCSV ~= countMaxCSV)
                        indexCSV = indexCSV + 1;
                    else
                        break
                    end
                end
            end

            if(indexCSV == countMaxCSV)
                break
            end

        end

    end

end




% load("../../data/training/trainingData.mat","trainingData","trainingRowLabels","trainingMetadata");
% %%
% trainingDataBeeFrequencies = cell(1,length(trainingData));
% 
% parfor imageNum = 1:length(trainingData)-1
% 
%     image = trainingData{imageNum};
%     FS = averagePRF(trainingMetadata(imageNum).Timestamps);
%     beeRows = find(trainingRowLabels{imageNum});
%     freqResults = cell(length(beeRows),2);
%     for rowNum = 1:length(beeRows)
% 
%         row = beeRows(rowNum);
%         freqResults{rowNum,1} = row;
%         fftResult = abs(fft(image(row,:))).^2;
%         fftPositive = fftResult(1:end/2);
%         harmonicIndex = estimateFundamentalFreq(fftPositive);
%         harmonic = (FS/1024)*harmonicIndex;
%         freqResults{rowNum,2} = harmonic;
% 
%     end
%     trainingDataBeeFrequencies{imageNum} = freqResults;
% 
% end
% save("trainingDataBeeFrequencies.mat","trainingDataBeeFrequencies","-v7.3");
% %%
% load("../../data/testing/testingData.mat","testingData","testingRowLabels","testingMetadata");
% %%
% testingDataBeeFrequencies = cell(1,length(testingData));
% 
% parfor imageNum = 1:length(testingData)-1
% 
%     image = testingData{imageNum};
%     FS = averagePRF(testingMetadata(imageNum).Timestamps);
%     beeRows = find(testingRowLabels{imageNum});
%     freqResults = cell(length(beeRows),2);
%     for rowNum = 1:length(beeRows)
% 
%         row = beeRows(rowNum);
%         freqResults{rowNum,1} = row;
%         fftResult = abs(fft(image(row,:))).^2;
%         fftPositive = fftResult(1:end/2);
%         harmonicIndex = estimateFundamentalFreq(fftPositive);harmonic = (FS/1024)*harmonicIndex;
%         freqResults{rowNum,2} = harmonic;
% 
%     end
%     testingDataBeeFrequencies{imageNum} = freqResults;
% 
% end
% save("testingDataBeeFrequencies.mat","testingDataBeeFrequencies","-v7.3");