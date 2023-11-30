function writeResultsToTxtFile(classifierName,results,dir)

% SPDX-License-Identifier: BSD-3-Clause

arguments
    classifierName (1,1) string
    results (1,1) struct
    dir (1,1) string
end

fd = fopen(dir + filesep + classifierName + "Results.txt", "w");

if any(contains(fieldnames(results),"Row"))

    fprintf(fd,"Row results:\n");

    fprintf(fd,"Confusion\n");
    fprintf(fd,"\t%6u\t%6u\n",results.Row.Confusion(1,1),results.Row.Confusion(1,2));
    fprintf(fd,"\t%6u\t%6u\n",results.Row.Confusion(2,1),results.Row.Confusion(2,2));

    fprintf(fd,"Precision = %.3f\n",results.Row.Precision);
    fprintf(fd,"Recall = %.3f\n",results.Row.Recall);
    fprintf(fd,"F2 = %.3f\n",results.Row.F2);
    fprintf(fd,"MCC = %.3f\n",results.Row.MCC);
    fprintf(fd,"Accuracy = %.3f\n",results.Row.Accuracy);

    fprintf(fd,"\n\n");

end

fprintf(fd,"Image results:\n");

fprintf(fd,"Confusion\n");
fprintf(fd,"\t%6u\t%6u\n",results.Image.Confusion(1,1),results.Image.Confusion(1,2));
fprintf(fd,"\t%6u\t%6u\n",results.Image.Confusion(2,1),results.Image.Confusion(2,2));

fprintf(fd,"Precision = %.3f\n",results.Image.Precision);
fprintf(fd,"Recall = %.3f\n",results.Image.Recall);
fprintf(fd,"F2 = %.3f\n",results.Image.F2);
fprintf(fd,"MCC = %.3f\n",results.Image.MCC);
fprintf(fd,"Accuracy = %.3f\n",results.Image.Accuracy);

fclose(fd);

end
