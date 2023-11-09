function selectBestSamplingParams(classifierName)
% selectBestSamplingParams select the best under/oversampling parameteers
%
%   selectBestSamplingParams(classifierName) collects the
%   data-sampling grid search results for a given classifier, then selects
%   and save which grid parameters minimized the objective function.
%

% SPDX-License-Identifier: BSD-3-Clause

arguments
    classifierName (1,1) string
end

beehiveDataSetup;

% Find all the results files
files = dir(samplingResultsDir + filesep + classifierName + "Undersample*.mat");
filenames = string({files.name});

if isempty(files)
    error("Results files for " + classifierName + " don't exist");
end

% Load in the results
for fileNum = 1:numel(filenames)
    results(fileNum) = load(samplingResultsDir + filesep + filenames(fileNum));
end

% Find the parameters that minimized the objective function
[objective,minIdx] = min([results.objective]);

% Get the classifier's hyperparameters; we will want to know these later during
% hyperparmaeter tuning, that way we can save these "default" hyperparameters if
% they gave a better result than any of the hyperparameter settings that
% bayesopt explored.
classifierParams = results(minIdx).userdata.Classifier.Hyperparams;

% Save the best parameters
samplingParams.UndersampleRatio = results(minIdx).undersampleRatio;
samplingParams.NOversample = results(minIdx).nOversample;

% Save the full classification results
classificationResults = results(minIdx).userdata;
classificationResults = rmfield(classificationResults,"Classifier");

disp(objective)
disp(samplingParams)

save(samplingResultsDir + filesep + classifierName + "BestParams",...
    "samplingParams","objective","classifierParams","classificationResults","-v7.3");

end
