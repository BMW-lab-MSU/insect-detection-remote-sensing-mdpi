load("../../data/testing/testingData.mat","testingImgLabels");

baseDir = "../../results/changepoint-results/";
%%
load(baseDir + "rowResultsOriginal_matlab.mat");
[rowOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
%%
load(baseDir + "colResultsOriginal_matlab.mat");
[colOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
%%
load(baseDir + "bothResultsOriginal_matlab.mat");
[bothOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(baseDir + "rowResultsFiltered_matlab.mat");
% [rowFilteredMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(baseDir + "colResultsFiltered_matlab.mat");
% [colFilteredMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(baseDir + "bothResultsFiltered_matlab.mat");
% [bothFilteredMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
%%
load(baseDir + "rowResultsOriginal_gfpop.mat");
[rowOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
%%
load(baseDir + "colResultsOriginal_gfpop.mat");
[colOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
%%
load(baseDir + "bothResultsOriginal_gfpop.mat");
[bothOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(baseDir + "rowResultsFiltered_gfpop.mat");
% [rowFilteredGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(baseDir + "colResultsFiltered_gfpop.mat");
% [colFilteredGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
% %%
% load(baseDir + "bothResultsFiltered_gfpop.mat");
% [bothFilteredGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels);
%%
figure(1); clf;
% subplot(241); confusionchart(rowFilteredGfpop); title("gfpop Filtered Rows");
% subplot(242); confusionchart(colFilteredGfpop); title("gfpop Filtered Cols");
% subplot(243); confusionchart(rowFilteredMat); title("matlab Filtered Rows");
% subplot(244); confusionchart(colFilteredMat); title("matlab Filtered Cols");
subplot(141); confusionchart(rowOriginalGfpop); title("gfpop Original Rows");
subplot(142); confusionchart(colOriginalGfpop); title("gfpop Original Cols");
subplot(143); confusionchart(rowOriginalMat); title("matlab Original Rows");
subplot(144); confusionchart(colOriginalMat); title("matlab Original Cols");

figure(2); clf;
% subplot(221); confusionchart(bothFilteredGfpop); title("gfpop Filtered Both");
% subplot(222); confusionchart(bothFilteredMat); title("matlab Filtered Both");
subplot(121); confusionchart(bothOriginalGfpop); title("gfpop Original Both");
subplot(122); confusionchart(bothOriginalMat); title("matlab Original Both");

