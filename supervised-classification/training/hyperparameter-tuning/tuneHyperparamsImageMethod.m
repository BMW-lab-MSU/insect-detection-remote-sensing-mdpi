function tuneHyperparamsImageMethod(classifierName,classifierType,opts)

arguments
    classifierName (1,1) string
    classifierType (1,1) function_handle
    opts.UseParallel = false
    opts.UseGPU = false
    opts.NIterations = 15
end

% Seed the random number generator for reproducibility
rng(7,'twister');

if opts.UseParallel
    if isempty(gcp('nocreate'))
        parpool();
    end
end

% Set up data paths
beehiveDataSetup;

% Load in the best data sampling parameters for the classifier
load(default2dCNNResultsDir + filesep + ...
    classifierName + "ManualParamTraining","objective","userdata");

% Keep track of the original objective function value that way we know
% if the default hyperparameters were best or not
originalObjective = objective;
originalHyperparameters = userdata.Classifier.Hyperparams;
disp("originalObjective = " + originalObjective);

% Load in the optimizable hyperparameters for the classifier
load(trainingDataDir + filesep + classifierName + "HyperparameterSearchValues");

% Load in the training data
load(trainingDataDir + filesep + "trainingData","trainingData",...
    "trainingImgLabels");

% Load in the validation data
load(validationDataDir + filesep + "validationData",...
    "validationData","validationImgLabels");

% Create the minimization function for bayesopt
minfcn = @(optimizable)validationObjFcn(classifierType,trainingData,...
    trainingImgLabels,validationData,validationImgLabels,...
    UseParallel=opts.UseParallel,UseGPU=opts.UseGPU,...
    Static=originalHyperparameters,Optimizable=optimizable);

% Do the parameter search!
results = bayesopt(minfcn,optimizableParams,IsObjectiveDeterministic=true,...
    UseParallel=false,AcquisitionFunctionName="expected-improvement-plus",...
    MaxObjectiveEvaluations=opts.NIterations,Verbose=1,PlotFcn=[]);

% If minimum objective found by bayesopt is lower than the minimum objective
% found during the data sampling grid search, use the hyperparameters associated
% with that iteration of bayesopt. Otherwise, we'll use the hyperpararmetersr
if results.MinObjective < originalObjective
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

end
