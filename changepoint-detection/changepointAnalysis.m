beehiveDataSetup;

load(testingDataDir + filesep + "testingData.mat","testingImgLabels","testingRowLabels");
rowLabelVector = cell2mat(testingRowLabels');

%%
load(changepointResultsDir + filesep + "rowResultsOriginal_matlab.mat");
[rowOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[rowOriginalMatRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
load(changepointResultsDir + filesep + "colResultsOriginal_matlab.mat");
[colOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[colOriginalMatRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
load(changepointResultsDir + filesep + "bothResultsOriginal_matlab.mat");
[bothOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[bothOriginalMatRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
% %%
% load(changepointResultsDir + filesep + "rowResultsFiltered_matlab.mat");
% [rowFilteredMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(changepointResultsDir + filesep + "colResultsFiltered_matlab.mat");
% [colFilteredMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(changepointResultsDir + filesep + "bothResultsFiltered_matlab.mat");
% [bothFilteredMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
%%
load(changepointResultsDir + filesep + "rowResultsOriginal_gfpop.mat");
[rowOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[rowOriginalGfpopRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
load(changepointResultsDir + filesep + "colResultsOriginal_gfpop.mat");
[colOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[colOriginalGfpopRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
%%
load(changepointResultsDir + filesep + "bothResultsOriginal_gfpop.mat");
[bothOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
rowPredictedVector = cell2mat(results{1,2}');
[bothOriginalGfpopRows,~,~] = analyzeResults(logical(rowPredictedVector),rowLabelVector);
% %%
% load(changepointResultsDir + filesep + "rowResultsFiltered_gfpop.mat");
% [rowFilteredGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(changepointResultsDir + filesep + "colResultsFiltered_gfpop.mat");
% [colFilteredGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(changepointResultsDir + filesep + "bothResultsFiltered_gfpop.mat");
% [bothFilteredGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
%%
figure(1); clf;
% subplot(241); confusionchart(rowFilteredGfpop); title("gfpop Filtered Rows");
% subplot(242); confusionchart(colFilteredGfpop); title("gfpop Filtered Cols");
% subplot(243); confusionchart(rowFilteredMat); title("matlab Filtered Rows");
% subplot(244); confusionchart(colFilteredMat); title("matlab Filtered Cols");
subplot(141); confusionchart(rowOriginalGfpop); title("gfpop Original Rows - Images");
subplot(142); confusionchart(colOriginalGfpop); title("gfpop Original Cols - Images");
subplot(143); confusionchart(rowOriginalMat); title("matlab Original Rows - Images");
subplot(144); confusionchart(colOriginalMat); title("matlab Original Cols - Images");

figure(2); clf;
% subplot(221); confusionchart(bothFilteredGfpop); title("gfpop Filtered Both");
% subplot(222); confusionchart(bothFilteredMat); title("matlab Filtered Both");
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