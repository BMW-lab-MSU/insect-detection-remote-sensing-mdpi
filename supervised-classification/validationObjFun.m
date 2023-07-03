function [objective, constraints, userdata] = validationObjFcn(classifier, ...
    trainingData, trainingLabels, validationData, validationLabels, opts)
% SPDX-License-Identifier: BSD-3-Clause
arguments
    classifier Classifier
    trainingData {:,1} cell
    trainingLabels
    validationData {:,1} cell
    validationLabels
    opts.UseParallel (1,1) logical = false
end

% TODO: I think I have to construct the classifier in this function in order to do the Bayesian hyperparaemter tuning.
%       The input parmaeters for the classifier constructor need to the be optimizable variables.
% classifier = ClassifierConstructor(params);


statset('UseParallel', opts.UseParallel);

% Train the model
fit(classifier,trainingData,traininglabels);

% Predict labels on the validation set
predLabels = predict(classifier,validationData);

% Compute performance metrics
confusionMatrix = confusionmat(validationLabels, predLabels);


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
