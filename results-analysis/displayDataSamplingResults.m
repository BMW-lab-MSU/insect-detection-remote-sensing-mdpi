function displayDataSamplingResults(classifierName)
% displayDataSamplingResults display results from the data sampling grid search.
%
%   displayDataSamplingResults(classifierName) displays the results for the
%   classifier referred to by classifierName. classifierName corresponds to the
%   name used when saving results files, not the name of the class that
%   implements the classifier.

% SPDX-License-Identifier: BSD-3-Clause

beehiveDataSetup;

% Find all the data-sampling results files
files = dir(samplingResultsDir + filesep + classifierName + "Undersample*.mat");
filenames = string({files.name});

% Load in the results
for fileNum = 1:numel(filenames)
    results(fileNum) = load(samplingResultsDir + filesep + filenames(fileNum));
end

% Display the results
[results.objective]
[results.undersampleRatio]

% Plot the results as a surface plot
undersampleGrid = reshape([results.undersampleRatio],4,[]);
oversampleGrid = reshape([results.nOversample],4,[]);;
objective = reshape([results.objective],4,[]);


surfc(undersampleGrid,oversampleGrid,objective);
xlabel("undersampling")
ylabel("oversampling")


end

