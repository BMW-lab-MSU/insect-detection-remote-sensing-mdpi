function trainRowFeatureMethod(classifierName,classifierConstructor,opts)

arguments
    classifierName (1,1) string
    classifierConstructor (1,1) function_handle
    opts.UseParallel = false
    opts.UseGPU = false
end

if opts.UseParallel
    if isempty(gcp('nocreate'))
        parpool();
    end

    statset(UseParallel=opts.UseParallel);
end

% Set up data paths
beehiveDataSetup;

% Load in the best data sampling parameters for the classifier
load(samplingResultsDir + filesep + classifierName + "BestParams",...
    "samplingParams");

% Load in the hyperparameters
load(hyperparameterResultsDir + filesep + classifierName + "Hyperparams",...
    "hyperparams");

% Load in the training data
load(trainingDataDir + filesep + "trainingData","trainingData",...
    "trainingRowLabels","trainingMetadata");
load(trainingDataDir + filesep + "trainingFeatures","trainingFeatures");

% Load in the validation data
load(validationDataDir + filesep + "validationData",...
    "validationData","validationRowLabels","validationMetadata");
load(validationDataDir + filesep + "validationFeatures","validationFeatures");

% Combine the training and validation data into one set for training
combinedData = horzcat(trainingData,validationData);
combinedFeatures = horzcat(trainingFeatures,validationFeatures);
combinedLabels = horzcat(trainingRowLabels,validationRowLabels);
combinedMetadata = horzcat({trainingMetadata.Timestamps},...
    {validationMetadata.Timestamps});

% Free up some memory
clear "trainingData" "trainingMetadata" "validationData" "validationMetadata" "validationRowLabels" "trainingRowLabels" "trainingFeatures" validationFeatures";

% Undersample/oversampling the data using the best parameters found during the
% data sampling grid search
[~,labels,features] = rowDataSampling(samplingParams.UndersampleRatio,...
    samplingParams.NOversample,combinedData,combinedLabels,...
    combinedMetadata,combinedFeatures,UseParallel=opts.UseParallel);

% Free up more unneeded memory
clear "combinedData" "combinedMetadata" "combinedFeatures" "combinedLabels"

% Assmeble the classifier's hyperparameter arguments
params = classifierConstructor().formatOptimizableParams(hyperparams);

classifierArgs = namedargs2cell(params);

if opts.UseGPU
    % NOTE: not all classifiers support GPU acceleration; the ones that don't
    %       support GPU acceleration don't have a UseGPU argument, so these
    %       classifiers will raise an error if UseGPU is passed in. 
    classifierArgs = horzcat(classifierArgs, {'UseGPU'}, opts.UseGPU);
end

% Construct the classifier
classifier = classifierConstructor(classifierArgs{:});

% Train the classifier
fit(classifier,features,labels);

% Save the classifier
if ~exist(finalClassifierDir)
    mkdir(trainingResultsDir,"classifiers");
end

save(finalClassifierDir + filesep + classifierName,"classifier","-v7.3");

end
