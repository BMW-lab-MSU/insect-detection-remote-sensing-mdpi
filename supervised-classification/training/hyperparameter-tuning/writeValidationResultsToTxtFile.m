function writeValidationResultsToTxtFile(classifierName)

arguments
    classifierName (1,1) string
end

% Setup data paths
beehiveDataSetup;

% Load in the hyperparameter tuning results
load(hyperparameterResultsDir + filesep + classifierName + "Hyperparams.mat","results");

% Find the results with the minimum objective
minIdx = results.IndexOfMinimumTrace(end);
classificationResults = results.UserDataTrace{minIdx};

% Write the classification results to the output text file
fd = fopen(hyperparameterResultsDir + filesep + classifierName + "Results.txt", "w");

fprintf(fd,"Confusion\n");
fprintf(fd,"\t%6u\t%6u\n",classificationResults.Confusion(1,1),classificationResults.Confusion(1,2));
fprintf(fd,"\t%6u\t%6u\n",classificationResults.Confusion(2,1),classificationResults.Confusion(2,2));

fprintf(fd,"Precision = %.3f\n",classificationResults.Precision);
fprintf(fd,"Recall = %.3f\n",classificationResults.Recall);
fprintf(fd,"F2 = %.3f\n",classificationResults.F2);
fprintf(fd,"MCC = %.3f\n",classificationResults.MCC);
fprintf(fd,"Accuracy = %.3f\n",classificationResults.Accuracy);

fclose(fd);

end

