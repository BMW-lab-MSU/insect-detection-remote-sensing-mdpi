function selectBestSamplingParams(classifierName,resultsDir)
% selectBestSamplingParams select the best under/oversampling parameteers
%
%   selectBestSamplingParams(classifierName,resultsDir) collects the
%   data-sampling grid search results for a given classifier, then selects
%   and save which grid parameters minimized the objective function.
%

% SPDX-License-Identifier: BSD-3-Clause

arguments
    classifierName (1,1) string
    resultsDir (1,1) string
end

% Find all the results files
files = dir(resultsDir + filesep + classifierName + "Undersample*.mat");
filenames = string({files.name});

if isempty(files)
    error("Results files for " + classifierName + " don't exist");
end

% Load in the results
for fileNum = 1:numel(filenames)
    results(fileNum) = load(resultsDir + filesep + filenames(fileNum));
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

disp(objective)
disp(samplingParams)

save(resultsDir + filesep + classifierName + "BestParams",...
    "samplingParams","objective","classifierParams","-v7.3");

end
