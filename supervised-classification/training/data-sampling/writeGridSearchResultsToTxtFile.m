function writeGridSearchResultsToTxtFile(classifierName,rowResults,samplingParams,classifierParams)

arguments
    classifierName (1,1) string
    rowResults (1,1)
    samplingParams (1,1)
    classifierParams (1,1)
end

% Setup data paths
beehiveDataSetup;

% Open output file
fd = fopen(samplingResultsDir + filesep + classifierName + "Results.txt", "w");


% Compute the image-based results
imageResults.Confusion = imageConfusion(rowResults.PredictedLabels,rowResults.TrueLabels);

[a, p, r, f2, ~, mcc] = analyzeConfusion(imageResults.Confusion);
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

fprintf(fd,"\n\n");

fprintf(fd,"Sampling parameters:\n");

fprintf(fd,"Undersample ratio = %f\n",samplingParams.UndersampleRatio);
fprintf(fd,"# synthetic insects = %f\n",samplingParams.NOversample);

fprintf(fd,"\n\n");

fprintf(fd,"Hyperparameters:\n");

for field = string(fieldnames(classifierParams))'
    if isnumeric(classifierParams.(field)) | islogical(classifierParams.(field))
        n = numel(classifierParams.(field));
        format = "%s =";
        for i = 1:n
            format = format + " %g";
        end
        format = format + "\n";
        fprintf(fd,format,field,classifierParams.(field));
    elseif ischar(classifierParams.(field)) | isstring(classifierParams.(field))
        fprintf(fd,"%s = %s\n",field,classifierParams.(field));
    elseif iscategorical(classifierParams.(field))
        fprintf(fd,"%s = %s\n",field,string(classifierParams.(field)));
    else
        error("we didn't handle this hyperparameter type: %s",class(classifierParams.(field)))
    end
end

fclose(fd);

end

