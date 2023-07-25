function trainRowDataMethod(classifierName,classifierConstructor,opts)

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

% Load in the validation data
load(validationDataDir + filesep + "validationData",...
    "validationData","validationRowLabels","validationMetadata");

% Combine the training and validation data into one set for training
combinedData = vertcat(trainingData,validationData);
combinedLabels = vertcat(trainingRowLabels,validationRowLabels);
combinedMetadata = vertcat({trainingMetadata.Timestamps},...
    {validationMetadata.Timestamps});

% Free up some memory
clear "trainingData" "trainingMetadata" "validationData" "validationMetadata" "validationRowLabels" "trainingRowLabels";

% Undersample/oversampling the data using the best parameters found during the
% data sampling grid search
[data,labels,~] = rowDataSampling(samplingParams.UndersampleRatio,...
    samplingParams.NOversample,combinedData,combinedLabels,...
    combinedMetadata,UseParallel=opts.UseParallel);

% Assmeble the classifier's hyperparameter arguments
classifierArgs = namedargs2cell(hyperparams);

if opts.UseGPU
    % NOTE: not all classifiers support GPU acceleration; the ones that don't
    %       support GPU acceleration don't have a UseGPU argument, so these
    %       classifiers will raise an error if UseGPU is passed in. 
    classifierArgs = horzcat(classifierArgs, {'UseGPU'}, opts.UseGPU);
end

% Construct the classifier
classifier = classifierConstructor(classifierArgs);

% Train the classifier
fit(classifier,data,labels);

% Save the classifier
if ~exist(finalClassifierDir)
    mkdir(trainingResultsDir,"classifiers");
end

save(finalClassifierDir + filesep + classifierName,"classifier","-v7.3");

end
