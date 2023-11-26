beehiveDataSetup;

load(testingDataDir + filesep + "testingData.mat","testingImgLabels","testingRowLabels");
rowLabelVector = cell2mat(testingRowLabels');

dict = dictionary(["matlabRows","matlabCols","matlabBoth","gfpopRows","gfpopCols","gfpopBoth"],struct());

%%
load(changepointResultsDir + filesep + "matlabChptsRowsResults");
dict("matlabRows").Image = computeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
dict("matlabRows").Row = computeResults(logical(rowPredictedVector),rowLabelVector);

%%
load(changepointResultsDir + filesep + "matlabChptsColsResults");
dict("matlabCols").Image = computeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
dict("matlabCols").Row = computeResults(logical(rowPredictedVector),rowLabelVector);

%%
load(changepointResultsDir + filesep + "matlabChptsBothResults.mat");
dict("matlabBoth").Image = computeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
dict("matlabBoth").Row = computeResults(logical(rowPredictedVector),rowLabelVector);

%%
load(changepointResultsDir + filesep + "gfpopRowsResults.mat");
dict("gfpopRows").Image = computeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
dict("gfpopRows").Row = computeResults(logical(rowPredictedVector),rowLabelVector);

%%
load(changepointResultsDir + filesep + "gfpopColsResults.mat");
dict("gfpopCols").Image = computeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
dict("gfpopCols").Row = computeResults(logical(rowPredictedVector),rowLabelVector);

%%
load(changepointResultsDir + filesep + "gfpopBothResults.mat");
dict("gfpopBoth").Image = computeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
dict("gfpopBoth").Row = computeResults(logical(rowPredictedVector),rowLabelVector);

%%
writeToTxtFile(dict);


%%
function results = computeResults(true, predicted)
    results.Confusion = confusionmat(true,predicted);
    [a,p,r,f2,~,mcc] = analyzeConfusion(results.Confusion);
    results.Accuracy = a;
    results.Precision = p;
    results.Recall = r;
    results.F2 = f2;
    results.MCC = mcc;
end

function writeToTxtFile(results)
    beehiveDataSetup;

    methodNames = keys(results);

    fd = fopen(changepointResultsDir + filesep + "combinedResults.txt","w");

    for method = methodNames'
        fprintf(fd,"%s\n",method);
        fprintf(fd,"--------------------------\n");

        fprintf(fd,"Row results:\n");

        fprintf(fd,"Confusion\n");
        fprintf(fd,"\t%6u\t%6u\n",results(method).Row.Confusion(1,1),results(method).Row.Confusion(1,2));
        fprintf(fd,"\t%6u\t%6u\n",results(method).Row.Confusion(2,1),results(method).Row.Confusion(2,2));

        fprintf(fd,"Precision = %.3f\n",results(method).Row.Precision);
        fprintf(fd,"Recall = %.3f\n",results(method).Row.Recall);
        fprintf(fd,"F2 = %.3f\n",results(method).Row.F2);
        fprintf(fd,"MCC = %.3f\n",results(method).Row.MCC);
        fprintf(fd,"Accuracy = %.3f\n",results(method).Row.Accuracy);

        fprintf(fd,"\n\n");

        fprintf(fd,"Image results:\n");

        fprintf(fd,"Confusion\n");
        fprintf(fd,"\t%6u\t%6u\n",results(method).Image.Confusion(1,1),results(method).Image.Confusion(1,2));
        fprintf(fd,"\t%6u\t%6u\n",results(method).Image.Confusion(2,1),results(method).Image.Confusion(2,2));

        fprintf(fd,"Precision = %.3f\n",results(method).Image.Precision);
        fprintf(fd,"Recall = %.3f\n",results(method).Image.Recall);
        fprintf(fd,"F2 = %.3f\n",results(method).Image.F2);
        fprintf(fd,"MCC = %.3f\n",results(method).Image.MCC);
        fprintf(fd,"Accuracy = %.3f\n",results(method).Image.Accuracy);

        fprintf(fd,"\n\n");
    end

    fclose(fd);

end
