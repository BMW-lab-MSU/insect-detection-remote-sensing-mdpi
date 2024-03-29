function tuneHyperparamsRowFeatureMethod(classifierName,classifierType,opts)
% tuneHyperparamsRowFeatureMethod perform hyperparameter tuning for feature-based methods
%
%   tuneHyperparamsRowFeatureMethod(classifierName,classifierType) performs
%   hyperparameter tuning for the classifier specified by classifierName, e.g.,
%   LinearSVM. classifierType is a handle to the classifier's class, e.g.,
%   @SVM.
%
%   Name-value options:
%       UseParallel - Use the parallell computing toolbox. The hyperparameter
%                     tuning using bayesopt is not performed in parallel
%                     because that is not reproducible. However, othe
%                     computations can be performed in parallel. Defaults to
%                     false.
%       UseGPU      - Train using a GPU. Defaults to false.
%       NIterations - Number of iterations to use during Bayesian optimizaiton.
%                     Defaults to 15.

% SPDX-License-Identifier: BSD-3-Clause

arguments
    classifierName (1,1) string
    classifierType (1,1) function_handle
    opts.UseParallel = false
    opts.UseGPU = false
    opts.NIterations = 15
end

if opts.UseParallel
    if isempty(gcp('nocreate'))
        parpool();
    end
end

% Set up data paths
beehiveDataSetup;

% Load in the best data sampling parameters for the classifier
load(samplingResultsDir + filesep + classifierName + "BestParams",...
    "samplingParams","objective","classifierParams");

% Keep track of the original objective function value that way we know
% if the default hyperparameters were best or not
originalObjective = objective;
originalHyperparameters = classifierParams;
disp("originalObjective = " + originalObjective);

% Load in the optimizable hyperparameters for the classifier
load(trainingDataDir + filesep + classifierName + "HyperparameterSearchValues");

% Load in the training data and features
load(trainingDataDir + filesep + "trainingData","trainingData",...
    "trainingRowLabels","trainingMetadata");
load(trainingDataDir + filesep + "trainingFeatures");

% Load in the validation features
load(validationDataDir + filesep + "validationData","validationRowLabels");
load(validationDataDir + filesep + "validationFeatures");

% Undersample/oversampling the data using the best parameters found during the
% data sampling grid search
[~,labels,features] = rowDataSampling(samplingParams.UndersampleRatio,...
    samplingParams.NOversample,trainingData,trainingRowLabels,...
    {trainingMetadata.Timestamps},trainingFeatures,...
    UseParallel=opts.UseParallel);

% Free up some memory
clear "trainingData" "trainingMetadata";

% Create the minimization function for bayesopt
minfcn = @(optimizable)validationObjFcn(classifierType,features,labels,...
    validationFeatures,validationRowLabels,UseParallel=opts.UseParallel,...
    UseGPU=opts.UseGPU,Static=originalHyperparameters,Optimizable=optimizable);

% Seed the random number generator for reproducibility
rng(7,'twister');

% Do the parameter search!
results = bayesopt(minfcn,optimizableParams,IsObjectiveDeterministic=true,...
    UseParallel=false,AcquisitionFunctionName="expected-improvement-plus",...
    MaxObjectiveEvaluations=opts.NIterations,Verbose=1,PlotFcn=[]);

% If minimum objective found by bayesopt is lower than the minimum objective
% found during the data sampling grid search, use the hyperparameters associated
% with that iteration of bayesopt. Otherwise, we'll use the hyperpararmetersr
if results.MinObjective < originalObjective
    % TODO: it would be more convenient to save the parameters from the
    %       the classifier object itself because they are formatted how
    %       the classifier needs them. The bayesopt parameters are not
    %       always in the right format because some parameters, e.g.
    %       FilterSize, needs one variable per layer in bayesopt, but is
    %       an array for the classifier. Saving from the classifier also
    %       saves all parameters, not just the the optimzable ones; this
    %       is good if we used a non-default parameter for one of the
    %       parameters we didn't optimize.
    hyperparams = table2struct(bestPoint(results));
else
    hyperparams = originalHyperparameters;
end

% Save the best hyperparameter settings
filename = classifierName + "Hyperparams";

if ~exist(hyperparameterResultsDir)
    mkdir(trainingResultsDir,"hyperparameter-tuning");
end

save(hyperparameterResultsDir + filesep + filename,...
    "hyperparams","results","-v7.3");

writeValidationResultsToTxtFile(classifierName,true,results,validationRowLabels);

end
