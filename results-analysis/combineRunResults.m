clear;
%% Load in the validation labels
% XXX: we wouldn't have to do this if we had saved the actual best results and
% metrics after hyperparameter tuning, instead of just saving the bayesopt
% results object. We also wouldn't need the getValidationResults function.
% This is just a note for the future to consider refactoring the code...
beehiveDataSetup;
load(validationDataDir + filesep + "validationData","validationRowLabels");

%% Setup parameters
combinedDir = "../combined-results";
dirs = ["../results","../results2","../results3"];

classifiers = ["RUSBoost","AdaBoost","LinearSVM","StatsNeuralNetwork1Layer",...
    "StatsNeuralNetwork3Layer","StatsNeuralNetwork5Layer",...
    "StatsNeuralNetwork7Layer","CNN1d1Layer","CNN1d3Layer","CNN1d5Layer",...
    "CNN1d7Layer"];

classifiers2D = ["CNN2d1Layer","CNN2d3Layer","CNN2d5Layer","CNN2d7Layer"];

%% Validation results
disp("validation results")
disp("------------------")
for classifier = classifiers
    disp(classifier)
    for i = 1:numel(dirs)
        bayesoptResults = load(dirs(i) + filesep + "training" + filesep + "hyperparameter-tuning" + filesep + classifier + "Hyperparams.mat");
        
        results(i) = getValidationResults(classifier,true,dirs(i),bayesoptResults.results,validationRowLabels);
    end

    rowResults = [results.Row];
    imageResults = [results.Image];

    combined.Row.Accuracy.Mean = mean([rowResults.Accuracy]);
    combined.Row.Accuracy.Std = std([rowResults.Accuracy]);
    combined.Row.Precision.Mean = mean([rowResults.Precision]);
    combined.Row.Precision.Std = std([rowResults.Precision]);
    combined.Row.Recall.Mean = mean([rowResults.Recall]);
    combined.Row.Recall.Std = std([rowResults.Recall]);
    combined.Row.F2.Mean = mean([rowResults.F2]);
    combined.Row.F2.Std = std([rowResults.F2]);
    combined.Row.MCC.Mean = mean([rowResults.MCC]);
    combined.Row.MCC.Std = std([rowResults.MCC]);
    combined.Image.Accuracy.Mean = mean([imageResults.Accuracy]);
    combined.Image.Accuracy.Std = std([imageResults.Accuracy]);
    combined.Image.Precision.Mean = mean([imageResults.Precision]);
    combined.Image.Precision.Std = std([imageResults.Precision]);
    combined.Image.Recall.Mean = mean([imageResults.Recall]);
    combined.Image.Recall.Std = std([imageResults.Recall]);
    combined.Image.F2.Mean = mean([imageResults.F2]);
    combined.Image.F2.Std = std([imageResults.F2]);
    combined.Image.MCC.Mean = mean([imageResults.MCC]);
    combined.Image.MCC.Std = std([imageResults.MCC]);
    
    writeResultsToTxtFile(classifier,combined,combinedDir + filesep + "validation")
end

for classifier = classifiers2D
    clear combined;
    clear results;
    disp(classifier)
    for i = 1:numel(dirs)
        bayesoptResults = load(dirs(i) + filesep + "training" + filesep + "hyperparameter-tuning" + filesep + classifier + "Hyperparams.mat");
        
        results(i) = getValidationResults(classifier,false,dirs(i),bayesoptResults.results,validationRowLabels);
    end

    imageResults = [results.Image];

    combined.Image.Accuracy.Mean = mean([imageResults.Accuracy]);
    combined.Image.Accuracy.Std = std([imageResults.Accuracy]);
    combined.Image.Precision.Mean = mean([imageResults.Precision]);
    combined.Image.Precision.Std = std([imageResults.Precision]);
    combined.Image.Recall.Mean = mean([imageResults.Recall]);
    combined.Image.Recall.Std = std([imageResults.Recall]);
    combined.Image.F2.Mean = mean([imageResults.F2]);
    combined.Image.F2.Std = std([imageResults.F2]);
    combined.Image.MCC.Mean = mean([imageResults.MCC]);
    combined.Image.MCC.Std = std([imageResults.MCC]);
    
    writeResultsToTxtFile(classifier,combined,combinedDir + filesep + "validation")
end


%% Testing results
disp("testing results")
disp("------------------")
for classifier = classifiers
    clear combined;
    clear results;
    disp(classifier)
    for i = 1:numel(dirs)
        testingResults = load(dirs(i) + filesep + "testing" + filesep + classifier + "Results.mat");
        
        results(i) = testingResults.results;
    end

    rowResults = [results.Row];
    imageResults = [results.Image];

    combined.Row.Accuracy.Mean = mean([rowResults.Accuracy]);
    combined.Row.Accuracy.Std = std([rowResults.Accuracy]);
    combined.Row.Precision.Mean = mean([rowResults.Precision]);
    combined.Row.Precision.Std = std([rowResults.Precision]);
    combined.Row.Recall.Mean = mean([rowResults.Recall]);
    combined.Row.Recall.Std = std([rowResults.Recall]);
    combined.Row.F2.Mean = mean([rowResults.F2]);
    combined.Row.F2.Std = std([rowResults.F2]);
    combined.Row.MCC.Mean = mean([rowResults.MCC]);
    combined.Row.MCC.Std = std([rowResults.MCC]);
    combined.Image.Accuracy.Mean = mean([imageResults.Accuracy]);
    combined.Image.Accuracy.Std = std([imageResults.Accuracy]);
    combined.Image.Precision.Mean = mean([imageResults.Precision]);
    combined.Image.Precision.Std = std([imageResults.Precision]);
    combined.Image.Recall.Mean = mean([imageResults.Recall]);
    combined.Image.Recall.Std = std([imageResults.Recall]);
    combined.Image.F2.Mean = mean([imageResults.F2]);
    combined.Image.F2.Std = std([imageResults.F2]);
    combined.Image.MCC.Mean = mean([imageResults.MCC]);
    combined.Image.MCC.Std = std([imageResults.MCC]);
    
    writeResultsToTxtFile(classifier,combined,combinedDir + filesep + "testing")
end

for classifier = classifiers2D
    clear combined;
    clear results;
    disp(classifier)
    for i = 1:numel(dirs)
        testingResults = load(dirs(i) + filesep + "testing" + filesep + classifier + "Results.mat");
        
        results(i) = testingResults.results;
    end

    imageResults = [results.Image];

    combined.Image.Accuracy.Mean = mean([imageResults.Accuracy]);
    combined.Image.Accuracy.Std = std([imageResults.Accuracy]);
    combined.Image.Precision.Mean = mean([imageResults.Precision]);
    combined.Image.Precision.Std = std([imageResults.Precision]);
    combined.Image.Recall.Mean = mean([imageResults.Recall]);
    combined.Image.Recall.Std = std([imageResults.Recall]);
    combined.Image.F2.Mean = mean([imageResults.F2]);
    combined.Image.F2.Std = std([imageResults.F2]);
    combined.Image.MCC.Mean = mean([imageResults.MCC]);
    combined.Image.MCC.Std = std([imageResults.MCC]);
    
    writeResultsToTxtFile(classifier,combined,combinedDir + filesep + "testing")
end



%% Extra functions
function [results] =  getValidationResults(classifierName,isRowMethod,dir,bayesResults,validationRowLabels)

arguments
    classifierName (1,1) string
    isRowMethod (1,1) logical
    dir (1,1) string
    bayesResults (1,1)
    validationRowLabels = []
end

if isRowMethod
    % Find the results with the minimum objective
    minIdx = bayesResults.IndexOfMinimumTrace(end);
    results.Row = bayesResults.UserDataTrace{minIdx};


    % Load in the sampling results (if it exists) to check if the default
    % parameters performed better than the parameters tried by bayesopt
    filepath = dir + filesep + "training" + filesep + "data-sampling" + filesep + classifierName + "BestParams.mat";
    if exist(filepath,"file")

        load(filepath,"classificationResults");
        
        if classificationResults.MCC > results.Row.MCC
            results.Row = classificationResults;
        end
    end

    if isfield(results.Row,"Classifier")
        results.Row = rmfield(results.Row,"Classifier");
    end

    if contains(classifierName,"CNN1d")
        trueLabels = DeepLearning1dClassifier.formatLabels(validationRowLabels);
    else
        trueLabels = StatsToolboxClassifier.formatLabels(validationRowLabels);
    end

    % Compute the image-based results
    results.Image.Confusion = imageConfusion(results.Row.PredictedLabels,trueLabels);
    
    [a, p, r, f2, ~, mcc] = analyzeConfusion(results.Image.Confusion);
    results.Image.Accuracy = a;
    results.Image.Precision = p;
    results.Image.Recall = r;
    results.Image.F2 = f2;
    results.Image.MCC = mcc;

else
    % Find the results with the minimum objective
    minIdx = bayesResults.IndexOfMinimumTrace(end);
    results.Image = bayesResults.UserDataTrace{minIdx};


    % Load in the default training results to check if the default
    % parameters performed better than the parameters tried by bayesopt
    filepath = dir + filesep + "training" + filesep + "default-params" + filesep + classifierName + "ManualParamTraining.mat";

    load(filepath,"userdata");
    
    if userdata.MCC > results.Image.MCC
        results.Image = userdata;
    end
    
    if isfield(results.Image,"Classifier")
        results.Image = rmfield(results.Image,"Classifier");
    end
end

end

function writeResultsToTxtFile(classifierName,results,dir)

arguments
    classifierName (1,1) string
    results (1,1) struct
    dir (1,1) string
end

fd = fopen(dir + filesep + classifierName + "Results.txt", "w");

if any(contains(fieldnames(results),"Row"))

    fprintf(fd,"Row results:\n");

    fprintf(fd,"Precision = %.3f (%.6f)\n",results.Row.Precision.Mean,results.Row.Precision.Std);
    fprintf(fd,"Recall = %.3f (%.6f)\n",results.Row.Recall.Mean,results.Row.Recall.Std);
    fprintf(fd,"F2 = %.3f (%.6f)\n",results.Row.F2.Mean,results.Row.F2.Std);
    fprintf(fd,"MCC = %.3f (%.6f)\n",results.Row.MCC.Mean,results.Row.MCC.Std);
    fprintf(fd,"Accuracy = %.3f (%.6f)\n",results.Row.Accuracy.Mean,results.Row.Accuracy.Std);

    fprintf(fd,"\n");

end

fprintf(fd,"Image results:\n");

fprintf(fd,"Precision = %.3f (%.6f)\n",results.Image.Precision.Mean,results.Image.Precision.Std);
fprintf(fd,"Recall = %.3f (%.6f)\n",results.Image.Recall.Mean,results.Image.Recall.Std);
fprintf(fd,"F2 = %.3f (%.6f)\n",results.Image.F2.Mean,results.Image.F2.Std);
fprintf(fd,"MCC = %.3f (%.6f)\n",results.Image.MCC.Mean,results.Image.MCC.Std);
fprintf(fd,"Accuracy = %.3f (%.6f)\n",results.Image.Accuracy.Mean,results.Image.Accuracy.Std);

fclose(fd);

end
