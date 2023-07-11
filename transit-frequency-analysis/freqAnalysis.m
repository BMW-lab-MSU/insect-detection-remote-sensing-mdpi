load("../../data/training/trainingData.mat","trainingData","trainingRowLabels","trainingMetadata");
%%
trainingDataBeeFrequencies = cell(1,length(trainingData));

for imageNum = 1:length(trainingData)

    image = trainingData{imageNum};
    FS = averagePRF(trainingMetadata(imageNum).Timestamps);
    beeRows = find(trainingRowLabels{imageNum});
    freqResults = cell(length(beeRows),2);
    for rowNum = 1:length(beeRows)

        row = beeRows(rowNum);
        freqResults{rowNum,1} = row;
        fftResult = abs(fft(image(row,:))).^2;
        fftPositive = fftResult(1:end/2);
        harmonicIndex = estimateFundamentalFreq(fftPositive);
        harmonic = (FS/1024)*harmonicIndex;
        freqResults{rowNum,2} = harmonic;

    end
    trainingDataBeeFrequencies{imageNum} = freqResults;

end
save("trainingDataBeeFrequencies.mat","trainingDataBeeFrequencies","-v7.3");
%%
load("../../data/testing/testingData.mat","testingData","testingRowLabels");
%%
testingDataBeeFrequencies = cell(1,length(testingData));

parfor imageNum = 1:length(testingData)

    image = testingData{imageNum};
    FS = averagePRF(trainingMetadata(imageNum).Timestamps);
    beeRows = find(testingRowLabels{imageNum});
    freqResults = cell(length(beeRows),2);
    for rowNum = 1:length(beeRows)

        row = beeRows(rowNum);
        freqResults{rowNum,1} = row;
        fftResult = abs(fft(image(row,:))).^2;
        fftPositive = fftResult(1:end/2);
        harmonicIndex = estimateFundamentalFreq(fftPositive);harmonic = (FS/1024)*harmonicIndex;
        freqResults{rowNum,2} = harmonic;

    end
    testingDataBeeFrequencies{imageNum} = freqResults;

end
save("testingDataBeeFrequencies.mat","testingDataBeeFrequencies","-v7.3");