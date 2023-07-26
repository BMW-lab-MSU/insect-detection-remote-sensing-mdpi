function testImageMethod(classifierName)

arguments
    classifierName (1,1) string
end

% Setup paths
beehiveDataSetup;

% Load in the classifier
load(finalClassifierDir + filesep + classifierName,"classifier");

% Load in the testing data and labels
load(testingDataDir + filesep + "testingData","testingImgLabels","testingData");

results.Image.TrueLabels = classifier.formatLabels(testingRowLabels);

% Predict the image labels
results.Image.PredictedLabels = predict(classifier,testingData);

% Compute the image results
results.Image.Confusion = confusionmat(results.Image.TrueLabels,...
    results.Image.PredictedLabels);

[a, p, r, f2, mcc] = analyzeConfusion(results.Image.Confusion);
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
