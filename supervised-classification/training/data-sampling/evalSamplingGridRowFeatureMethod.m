function evalSamplingGridRowFeatureMethod(classifierType,gridIndex,params,opts)

arguments
    classifierType function_handle
    gridIndex (1,1) {mustBeInteger}
    params.ClassifierParams = {}
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

% Set the sampling grid parameters
load(trainingDataDir + filesep + "samplingGridRowBased");
undersampleRatio = samplingGrid(gridIndex,:).UndersamplingRatio;
nOversample = samplingGrid(gridIndex,:).NSyntheticInsect;

% Load in the training data
load(trainingDataDir + filesep + "trainingData","trainingData",...
    "trainingRowLabels","trainingMetadata");
load(trainingDataDir + filesep + "trainingFeatures");

% Load in the validation data
load(validationDataDir + filesep + "validationData","validationRowLabels");
load(validationDataDir + filesep + "validationFeatures");

% Undersample/oversampling the data
[~,labels,features] = rowDataSampling(undersampleRatio,nOversample,...
    trainingData,trainingRowLabels,{trainingMetadata.Timestamps},trainingFeatures,UseParallel=opts.UseParallel);

% Train and evaluate the classifier with the given data sampling parameters
[objective,~,userdata] = validationObjFcn(classifierType,features,labels,...
    validationFeatures,validationRowLabels,UseParallel=opts.UseParallel,...
    UseGPU=opts.UseGPU,Static=params.ClassifierParams);

disp("objective = " + objective);

% Save results so we can do parameter selection later
filename = userdata.Classifier.Name + "Undersample" + undersampleRatio + ...
    "Oversample" + nOversample + ".mat";

if ~exist(trainingResultsDir + filesep + "data-sampling")
    mkdir(trainingResultsDir,"data-sampling");
end

save(trainingResultsDir + filesep + "data-sampling" + filesep + filename,...
    "objective","userdata","undersampleRatio","nOversample",'-v7.3');

end
