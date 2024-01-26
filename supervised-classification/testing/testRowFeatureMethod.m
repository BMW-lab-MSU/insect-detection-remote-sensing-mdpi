function testRowFeatureMethod(classifierName)
% testRowFeatureMethod test row- and feature-based algorithm on the testing set
%
%   testRowFeatureMethod(classifierName) tests the classifer referred to by
%   classifierName. 
% 
%   classifierName is the classifer name used when saving files,
%   not the name of the class that implements the classifier, e.g.
%   StatsNeuralNetwork1Layer, not StatsNeuralNetwork.

% SPDX-License-Identifier: BSD-3-Clause

arguments
    classifierName (1,1) string
end

% Setup paths
beehiveDataSetup;

% Load in the classifier
load(finalClassifierDir + filesep + classifierName,"classifier");

% Load in the testing features and labels
load(testingDataDir + filesep + "testingFeatures","testingFeatures");
load(testingDataDir + filesep + "testingData","testingRowLabels");

results.Row.TrueLabels = classifier.formatLabels(testingRowLabels);

% Predict the row labels
results.Row.PredictedLabels = predict(classifier,testingFeatures);

% Compute the row results
results.Row.Confusion = confusionmat(results.Row.TrueLabels,...
    results.Row.PredictedLabels);

[a, p, r, f2, ~, mcc] = analyzeConfusion(results.Row.Confusion);
results.Row.Accuracy = a;
results.Row.Precision = p;
results.Row.Recall = r;
results.Row.F2 = f2;
results.Row.MCC = mcc;

% Compute the image results
[imageConf,imageTrue,imagePred]  = ...
    imageConfusion(results.Row.PredictedLabels,results.Row.TrueLabels);
results.Image.Confusion = imageConf;
results.Image.PredictedLabels = imagePred;
results.Image.TrueLabels = imageTrue;

[a, p, r, f2, ~, mcc] = analyzeConfusion(results.Image.Confusion);
results.Image.Accuracy = a;
results.Image.Precision = p;
results.Image.Recall = r;
results.Image.F2 = f2;
results.Image.MCC = mcc;

% Display results
disp('Row results')
disp(results.Row.Confusion)
disp(results.Row)
disp('Image results')
disp(results.Image.Confusion)
disp(results.Image)

% Save results
if ~exist(testingResultsDir,"dir")
    mkdir(baseResultsDir,"testing");
end

save(testingResultsDir + filesep + classifierName + "Results","results","-v7.3");

writeResultsToTxtFile(classifierName,results,testingResultsDir);

end
