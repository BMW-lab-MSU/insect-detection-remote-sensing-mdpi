function [objective,constraints,userdata] = ...
    validationObjFcn(classifierConstructor,...
    trainingData,trainingLabels,validationData,validationLabels,params,opts)
% SPDX-License-Identifier: BSD-3-Clause
arguments
    classifierConstructor function_handle
    trainingData 
    trainingLabels
    validationData 
    validationLabels
    params.Static = {}
    params.Optimizable = []
    opts.UseParallel (1,1) logical = false
    opts.UseGPU (1,1) logical = false
end

statset('UseParallel', opts.UseParallel);

% Assmeble the classifier's hyperparameter arguments
classifierArgs = {};

if ~isempty(params.Static)
    classifierArgs = horzcat(classifierArgs, namedargs2cell(params.Static));
end

if ~isempty(params.Optimizable)
    classifierArgs = horzcat(classifierArgs, ...
        namedargs2cell(table2struct(params.Optimizable)));
end

classifierArgs = horzcat(classifierArgs, {'UseGPU'}, opts.UseGPU);

% Construct classifier
if isempty(classifierArgs)
    % use default hyperapameters
    classifier = classifierConstructor();
else
    classifier = classifierConstructor(classifierArgs{:});
end

% Train the model
fit(classifier,trainingData,trainingLabels);

% Predict labels on the validation set
predLabels = predict(classifier,validationData);

% Compute performance metrics
trueLabels = classifier.formatLabels(validationLabels);
confusionMatrix = confusionmat(trueLabels, predLabels);

[accuracy, precision, recall, f2, f3, mcc] = analyzeConfusion(confusionMatrix);
objective = -mcc;

constraints = [];

userdata.Confusion = confusionMatrix;
userdata.Classifier = classifier;
userdata.Accuracy = accuracy;
userdata.Precision = precision;
userdata.Recall = recall;
userdata.F2 = f2;
userdata.F3 = f3;
userdata.MCC = mcc;
userdata.PredLabels = predLabels;
end
