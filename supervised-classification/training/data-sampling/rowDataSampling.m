function [newData,newLabels,newFeatures] = rowDataSampling(undersampleRatio,...
    nOversample,data,labels,timestamps,features,opts)
% rowDataSampling undersample and oversample data
%
%   [newData,newLabels] = rowDataSampling(undersampleRatio,nOversample,data,labels)
%   undersamples the majority class by undersampleRatio, and oversamples the
%   minority class by creating nOversample synthetic samples for each minorit
%   class sample. The return arguments have the undersampled samples removed
%   and the new samples added.

%   [newData,newLabels,newFeatures] = ...
%       rowDataSampling(undersampleRatio,nOversample,data,labels,timestamps,features)
%   undersamples the majority class by undersampleRatio, and oversamples the
%   minority class by creating nOversample synthetic samples for each minority
%   class sample. Features are removed for the undersampled samples, and created
%   for the synthetic samples. The return arguments have the undersampled samples
%   removed and the new samples added.
%
%   Name-value options:
%       MajorityLabel   - The label corresponding to the majority class.
%                         Defaults to 0.
%       UseParallel     - Use the parallel computing toolbox to create the
%                         synthetic examples in parallel.


% SPDX-License-Identifier: BSD-3-Clause

arguments
    undersampleRatio
    nOversample
    data
    labels
    timestamps = []
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
    newLabels{imageNum}(idxRemove) = [];

    if ~isempty(features)
        newFeatures{imageNum}(idxRemove,:) = [];
    end
end

% Oversampling
if isempty(features)
    parfor(imageNum = 1:numel(data), nWorkers)
        % Create synthesic insect time series rows
        [synthData,synthLabels] = createSyntheticData(newData{imageNum},...
            newLabels{imageNum},nOversample,Reproducible=true);

        newData{imageNum} = vertcat(newData{imageNum},synthData);
        newLabels{imageNum} = vertcat(newLabels{imageNum},synthLabels);
    end
else
    parfor(imageNum = 1:numel(data), nWorkers)
        avgSamplingFrequency = averagePRF(timestamps{imageNum});

        % Create synthetic insect features
        [synthFeatures,synthLabels] = ...
            createSyntheticFeatures(newData{imageNum},newLabels{imageNum},...
                nOversample,avgSamplingFrequency,Reproducible=true);
    
        newFeatures{imageNum} = vertcat(newFeatures{imageNum},synthFeatures);
        newLabels{imageNum} = vertcat(newLabels{imageNum},synthLabels);
    end
end
