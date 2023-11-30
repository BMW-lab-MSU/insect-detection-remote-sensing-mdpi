function displayDataSamplingResults(classifierName)

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

% Plot the results as a surface plot
undersampleGrid = reshape([results.undersampleRatio],4,[]);
oversampleGrid = reshape([results.nOversample],4,[]);;
objective = reshape([results.objective],4,[]);


surfc(undersampleGrid,oversampleGrid,objective);
xlabel("undersampling")
ylabel("oversampling")


end

