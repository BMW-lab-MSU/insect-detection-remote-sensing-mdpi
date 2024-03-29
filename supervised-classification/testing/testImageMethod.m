function testImageMethod(classifierName)
% testImageMethod test image-based algorithm on the testing set
%
%   testImageMethod(classifierName) tests the classifer referred to by
%   classifierName. 
% 
%   classifierName is the classifer name used when saving files,
%   not the name of the class that implements the classifier, e.g.
%   CNN2D5Layer, not CNN2D.

% SPDX-License-Identifier: BSD-3-Clause

arguments
    classifierName (1,1) string
end

% Setup paths
beehiveDataSetup;

% Load in the classifier
load(finalClassifierDir + filesep + classifierName,"classifier");

% Load in the testing data and labels
load(testingDataDir + filesep + "testingData","testingImgLabels","testingData");

results.Image.TrueLabels = classifier.formatLabels(testingImgLabels);

% Predict the image labels
results.Image.PredictedLabels = predict(classifier,testingData);

% Compute the image results
results.Image.Confusion = confusionmat(results.Image.TrueLabels,...
    results.Image.PredictedLabels);

[a, p, r, f2, ~, mcc] = analyzeConfusion(results.Image.Confusion);
results.Image.Accuracy = a;
results.Image.Precision = p;
results.Image.Recall = r;
results.Image.F2 = f2;
results.Image.MCC = mcc;

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
