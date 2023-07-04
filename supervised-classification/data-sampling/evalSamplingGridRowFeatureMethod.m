function evalSamplingGridRowFeatureMethod(classifierType,undersampleRatio,nOversample,opts)

arguments
    classifierType function_handle
    undersampleRatio (1,1) double
    nOversample (1,1) {mustBeInteger}
    opts.UseParallel = false
end

% Load in the training data
load(trainingDataDir + filesep + "trainingData","trainingData",...
    "trainingFeatures","trainingLabels");

% Load in the validation data
load(validationDataDir + filesep + "validationData","validationData",...
    "validationFeatures","validationLabels");

% Undersample/oversampling the data
[~,labels,features] = rowDataSampling(undersampleRatio,nOversample,...
    trainingData,trainingLabels,trainingFeatures,UseParallel=opts.UserParallel);

% Train and evaluate the classifier with the given data sampling parameters
[objective,~,userdata] = validationObjFcn(classifierType,features,labels,...
    validationDAta,validationLabels,UseParallel=opts.UseParallel);

% Save results so we can do parameter selection later
filename = string(class(classifierType)) + "Undersample" + undersampleRatio + ...
    "Oversample" + nOversample;

save(trainingResultsDir + filesep + "data-sampling" + filesep + filename,...
    "objective","userdata",'-v7.3');
    "objective","userdata",'-v7.3');

end
