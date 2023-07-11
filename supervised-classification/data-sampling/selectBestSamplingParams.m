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

% Save the best parameters
params.UndersampleRatio = results(minIdx).undersampleRatio;
params.NOversample = results(minIdx).nOversample;

disp(objective)
disp(params)

save(resultsDir + filesep + classifierName + "BestParams",...
    "params","objective","-v7.3");

end
