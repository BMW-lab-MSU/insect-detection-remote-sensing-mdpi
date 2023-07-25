function trainImageMethod(classifierName,classifierConstructor,opts)

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
end

% Set up data paths
beehiveDataSetup;

% Load in the hyperparameters
load(hyperparameterResultsDir + filesep + classifierName + "Hyperparams",...
    "hyperparams");

% Load in the training data
load(trainingDataDir + filesep + "trainingData","trainingData",...
    "trainingImgLabels");

% Load in the validation data
load(validationDataDir + filesep + "validationData",...
    "validationData","validationImgLabels");

% Combine the training and validation data into one set for training
data = horzcat(trainingData,validationData);
labels = horzcat(trainingImgLabels,validationImgLabels);

% Free up some memory
clear "trainingData" "validationData" "trainingImgLabels" "validationImgLabels";

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
fit(classifier,data,labels);

% Save the classifier
if ~exist(finalClassifierDir)
    mkdir(trainingResultsDir,"classifiers");
end

save(finalClassifierDir + filesep + classifierName,"classifier","-v7.3");

end
