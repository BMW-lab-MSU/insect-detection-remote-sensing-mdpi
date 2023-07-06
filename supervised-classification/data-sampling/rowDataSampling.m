function [newData,newLabels,newFeatures] = rowDataSampling(undersampleRatio,...
    nOversample,data,labels,features,opts)

arguments
    undersampleRatio
    nOversample
    data
    labels
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

% Undersample by removing rows from the majority class
parfor(imageNum = 1:numel(data), nWorkers)
    idxRemove = randomUndersample(labels,opts.MajorityLabel,...
        UndersamplingRatio=undersampleRatio,Reproducible=true);
    newData{imageNum}(idxRemove) = [];
    newLabels{imageNum}(idxRemove) = [];
end

% Oversampling
if isempty(features)
    % Create synthesic insect time series rows
    [synthData,synthLabels] = createSyntheticData(newData,newLabels,...
        nOversample,UseParallel=opts.UseParallel);

        newData = vertcat(newData,synthFeatures);
        newLabels = vertcat(newLabels,synthLabels);
else
    % Create synthetic insect features
    [synthFeatures,synthLabels] = createSyntheticFeatures(newData,newLabels,...
        nOversample,UseParallel=opts.UseParallel);
    
        newFeatures = vertcat(features,synthFeatures);
        newLabels = vertcat(newLabels,synthLabels);
end
