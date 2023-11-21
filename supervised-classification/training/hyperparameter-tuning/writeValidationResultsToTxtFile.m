function writeValidationResultsToTxtFile(classifierName,isRowMethod,results,validationRowLabels)

arguments
    classifierName (1,1) string
    isRowMethod (1,1) logical
    results (1,1)
    validationRowLabels = []
end

% Setup data paths
beehiveDataSetup;

% Open output file
fd = fopen(hyperparameterResultsDir + filesep + classifierName + "Results.txt", "w");

if isRowMethod
    % Find the results with the minimum objective
    minIdx = results.IndexOfMinimumTrace(end);
    rowResults = results.UserDataTrace{minIdx};

    % Load in the sampling results (if it exists) to check if the default
    % parameters performed better than the parameters tried by bayesopt
    filepath = samplingResultsDir + filesep + classifierName + "BestParams.mat";
    if exist(filepath,"file")

        load(filepath,"classificationResults");
        
        if classificationResults.MCC > rowResults.MCC
            rowResults = classificationResults;
        end
    end

    if contains(classifierName,"CNN1d")
        trueLabels = DeepLearning1dClassifier.formatLabels(validationRowLabels);
    else
        trueLabels = StatsToolboxClassifier.formatLabels(validationRowLabels);
    end

    % Compute the image-based results
    imageResults.Confusion = imageConfusion(rowResults.PredictedLabels,trueLabels);
    
    [a, p, r, f2, mcc] = analyzeConfusion(imageResults.Confusion);
    imageResults.Accuracy = a;
    imageResults.Precision = p;
    imageResults.Recall = r;
    imageResults.F2 = f2;
    imageResults.MCC = mcc;

    % Write the classification results to the output text file
    fprintf(fd,"Row results:\n");

    fprintf(fd,"Confusion\n");
    fprintf(fd,"\t%6u\t%6u\n",rowResults.Confusion(1,1),rowResults.Confusion(1,2));
    fprintf(fd,"\t%6u\t%6u\n",rowResults.Confusion(2,1),rowResults.Confusion(2,2));
    
    fprintf(fd,"Precision = %.3f\n",rowResults.Precision);
    fprintf(fd,"Recall = %.3f\n",rowResults.Recall);
    fprintf(fd,"F2 = %.3f\n",rowResults.F2);
    fprintf(fd,"MCC = %.3f\n",rowResults.MCC);
    fprintf(fd,"Accuracy = %.3f\n",rowResults.Accuracy);

    fprintf(fd,"\n\n");

    fprintf(fd,"Image results:\n");

    fprintf(fd,"Confusion\n");
    fprintf(fd,"\t%6u\t%6u\n",imageResults.Confusion(1,1),imageResults.Confusion(1,2));
    fprintf(fd,"\t%6u\t%6u\n",imageResults.Confusion(2,1),imageResults.Confusion(2,2));
    
    fprintf(fd,"Precision = %.3f\n",imageResults.Precision);
    fprintf(fd,"Recall = %.3f\n",imageResults.Recall);
    fprintf(fd,"F2 = %.3f\n",imageResults.F2);
    fprintf(fd,"MCC = %.3f\n",imageResults.MCC);
    fprintf(fd,"Accuracy = %.3f\n",imageResults.Accuracy);
    
else
    % Find the results with the minimum objective
    minIdx = results.IndexOfMinimumTrace(end);
    imageResults = results.UserDataTrace{minIdx};

    % Load in the default training results to check if the default
    % parameters performed better than the parameters tried by bayesopt
    filepath = default2dCNNResultsDir + filesep + classifierName + "ManualParamTraining.mat";

    load(filepath,"userdata");
    
    if userdata.MCC > imageResults.MCC
        imageResults = userdata;
    end
    
    % Write the classification results to the output text file
    fprintf(fd,"Image results:\n");

    fprintf(fd,"Confusion\n");
    fprintf(fd,"\t%6u\t%6u\n",imageResults.Confusion(1,1),imageResults.Confusion(1,2));
    fprintf(fd,"\t%6u\t%6u\n",imageResults.Confusion(2,1),imageResults.Confusion(2,2));
    
    fprintf(fd,"Precision = %.3f\n",imageResults.Precision);
    fprintf(fd,"Recall = %.3f\n",imageResults.Recall);
    fprintf(fd,"F2 = %.3f\n",imageResults.F2);
    fprintf(fd,"MCC = %.3f\n",imageResults.MCC);
    fprintf(fd,"Accuracy = %.3f\n",imageResults.Accuracy);
end

fclose(fd);

end

