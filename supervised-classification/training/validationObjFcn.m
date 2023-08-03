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

    % optimizableVariables can only be scalars. However, some of the classifier
    % parmaeters are vectors, such as the layer sizes, as this is more generic
    % and scalable. Consequently, some classifiers need to format/combine
    % the optimizable variables in a way that works with their constructor.
    % Some classifiers don't need to do any formatting, and won't modify
    % the optimizableVariables. bayesopt turns optimizable variables tin
    % tables, which are not compatible with the Name-Value pairs the
    % constructors need; all classifiers will turn the table into a struct,
    % which can then be converted into a cell array of Name-Value pairs that
    % the constructors can use.
    optimizableParams = ...
        classifierConstructor().formatOptimizableParams(params.Optimizable);

    classifierArgs = horzcat(classifierArgs,namedargs2cell(optimizableParams));
end

if opts.UseGPU
    % NOTE: not all classifiers support GPU acceleration; the ones that don't
    %       support GPU acceleration don't have a UseGPU argument, so these
    %       classifiers will raise an error if UseGPU is passed in. 
    classifierArgs = horzcat(classifierArgs, {'UseGPU'}, opts.UseGPU);
end

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
% TODO: update PredLabels to PredictedLabels
userdata.PredLabels = predLabels;
userdata.TrueLabels = trueLabels;
end
