function [newData,newLabels,newFeatures] = rowDataSampling(undersampleRatio,...
    nOversample,data,labels,timestamps,features,opts)

arguments
    undersampleRatio
    nOversample
    data
    labels
    timestamps
    features = []
    opts.MajorityLabel = 0
    opts.UseParallel = false
end

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end

newData = data;
newLabels = labels;
newFeatures = features;

% Undersample by removing rows from the majority class
for imageNum = 1:numel(data)
    idxRemove = randomUndersample(newLabels{imageNum},opts.MajorityLabel,...
        UndersamplingRatio=undersampleRatio,Reproducible=true);
    newData{imageNum}(idxRemove,:) = [];
    newFeatures{imageNum}(idxRemove,:) = [];
    newLabels{imageNum}(idxRemove) = [];
end

% Oversampling
if isempty(features)
    parfor(imageNum = 1:numel(data), nWorkers)
        % Create synthesic insect time series rows
        [synthData,synthLabels] = createSyntheticData(newData{imageNum},...
            newLabels{imageNum},nOversample);

        newData{imageNum} = vertcat(newData{imageNum},synthData);
        newLabels{imageNum} = vertcat(newLabels{imageNum},synthLabels);
    end
else
    parfor(imageNum = 1:numel(data), nWorkers)
        avgSamplingFrequency = averagePRF(timestamps{imageNum});

        % Create synthetic insect features
        [synthFeatures,synthLabels] = ...
            createSyntheticFeatures(newData{imageNum},newLabels{imageNum},...
                nOversample,avgSamplingFrequency);
    
        newFeatures{imageNum} = vertcat(newFeatures{imageNum},synthFeatures);
        newLabels{imageNum} = vertcat(newLabels{imageNum},synthLabels);
    end
end
