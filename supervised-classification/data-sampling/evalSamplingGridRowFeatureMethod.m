function evalSamplingGridRowFeatureMethod(classifierType,undersampleRatio,nOversample,opts)

arguments
    classifierType function_handle
    undersampleRatio (1,1) double
    nOversample (1,1) {mustBeInteger}
    opts.UseParallel = false
    opts.UseGPU = false
end

if opts.UseParallel
    if isempty(gcp('nocreate'))
        parpool();
    end
end

% Set up data paths
beehiveDataSetup;

% Load in the training data
load(trainingDataDir + filesep + "trainingData","trainingData",...
    "trainingRowLabels","trainingMetadata");
load(trainingDataDir + filesep + "trainingFeatures");

% Load in the validation data
load(validationDataDir + filesep + "validationData","validationData",...
    "validationRowLabels");
load(validationDataDir + filesep + "validationFeatures");

% Undersample/oversampling the data
[~,labels,features] = rowDataSampling(undersampleRatio,nOversample,...
    trainingData,trainingRowLabels,{trainingMetadata.Timestamps},trainingFeatures,UseParallel=opts.UseParallel);

% Train and evaluate the classifier with the given data sampling parameters
[objective,~,userdata] = validationObjFcn(classifierType,features,labels,...
    validationFeatures,validationRowLabels,UseParallel=opts.UseParallel,...
    UseGPU=opts.UseGPU);

% Save results so we can do parameter selection later
filename = string(class(classifierType)) ...
    + "Undersample" + undersampleRatio +  "Oversample" + nOversample;

save(trainingResultsDir + filesep + "data-sampling" + filesep + filename,...
    "objective","userdata",'-v7.3');

end
