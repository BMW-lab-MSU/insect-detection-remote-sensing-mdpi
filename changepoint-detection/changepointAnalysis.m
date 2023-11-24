beehiveDataSetup;

load(testingDataDir + filesep + "testingData.mat","testingImgLabels","testingRowLabels");
rowLabelVector = cell2mat(testingRowLabels');

%%
load(changepointResultsDir + filesep + "matlabChptsRowsResults");
[rowOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[rowOriginalMatRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
load(changepointResultsDir + filesep + "matlabChptsColsResults");
[colOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[colOriginalMatRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
load(changepointResultsDir + filesep + "matlabChptsBothResults.mat");
[bothOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[bothOriginalMatRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
load(changepointResultsDir + filesep + "gfpopRowsResults.mat");
[rowOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[rowOriginalGfpopRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
load(changepointResultsDir + filesep + "gfpopColsResults.mat");
[colOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[colOriginalGfpopRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
load(changepointResultsDir + filesep + "gfpopBothResults.mat");
[bothOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[bothOriginalGfpopRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
figure(1); clf;
subplot(141); confusionchart(rowOriginalGfpop); title("gfpop Original Rows - Images");
subplot(142); confusionchart(colOriginalGfpop); title("gfpop Original Cols - Images");
subplot(143); confusionchart(rowOriginalMat); title("matlab Original Rows - Images");
subplot(144); confusionchart(colOriginalMat); title("matlab Original Cols - Images");

figure(2); clf;
subplot(121); confusionchart(bothOriginalGfpop); title("gfpop Original Both - Images");
subplot(122); confusionchart(bothOriginalMat); title("matlab Original Both - Images");

figure(3); clf;
subplot(141); confusionchart(rowOriginalGfpopRows); title("gfpop Original Rows - Rows");
subplot(142); confusionchart(colOriginalGfpopRows); title("gfpop Original Cols - Rows");
subplot(143); confusionchart(rowOriginalMatRows); title("matlab Original Rows - Rows");
subplot(144); confusionchart(colOriginalMatRows); title("matlab Original Cols - Rows");

figure(4); clf;
subplot(121); confusionchart(bothOriginalGfpopRows); title("gfpop Original Both - Rows");
subplot(122); confusionchart(bothOriginalMatRows); title("matlab Original Both - Rows");
%%
finalImageResults = {rowOriginalGfpop,colOriginalGfpop,bothOriginalGfpop,rowOriginalMat,colOriginalMat,bothOriginalMat;
                     "Rows gfpop","Columns gfpop","Both gfpop","Rows Matlab","Columns Matlab","Both Matlab"};
save(changepointResultsDir + filesep + "finalImageResults.mat","finalImageResults","-v7.3");

finalRowResults = {rowOriginalGfpopRows,colOriginalGfpopRows,bothOriginalGfpopRows,rowOriginalMatRows,colOriginalMatRows,bothOriginalMatRows;
                     "Rows gfpop","Columns gfpop","Both gfpop","Rows Matlab","Columns Matlab","Both Matlab"};
save(changepointResultsDir + filesep + "finalRowResults.mat","finalRowResults","-v7.3");
