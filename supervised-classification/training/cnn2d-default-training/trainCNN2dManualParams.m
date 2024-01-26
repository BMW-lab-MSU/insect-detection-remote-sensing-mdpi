function trainCNN2dManualParams(classifierType,params,opts)
% trainCNN2dManualParams train a 2D CNN
%
%   trainCNN2dManualParams(classifierType,params) trains a 2D CNN. 
%   classifierType is a handle to the 2D CNN class, i.e. @CNN2D. params is a
%   struct containing fields for the CNN's hyperparameters.
%
%   Name-Value arguments:
%       UseParallel - Use the parallel computing toolbox
%       UseGPU      - Use a GPU for training

% SPDX-License-Identifier: BSD-3-Clause

arguments
    classifierType function_handle
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

% Load in the training data
load(trainingDataDir + filesep + "trainingData","trainingData",...
    "trainingImgLabels","trainingMetadata");

% Load in the validation data
load(validationDataDir + filesep + "validationData","validationData","validationImgLabels");


% Train and evaluate the classifier
[objective,~,userdata] = validationObjFcn(classifierType,trainingData,...
    trainingImgLabels,validationData,validationImgLabels,...
    UseParallel=opts.UseParallel,UseGPU=opts.UseGPU,...
    Static=params.ClassifierParams);

disp("objective = " + objective);

% Save results so we can do parameter selection later
filename = userdata.Classifier.Name + "ManualParamTraining.mat";

if ~exist(trainingResultsDir + filesep + "default-params")
    mkdir(trainingResultsDir,"default-params");
end

save(trainingResultsDir + filesep + "default-params" + filesep + filename,...
    "objective","userdata",'-v7.3');

end
