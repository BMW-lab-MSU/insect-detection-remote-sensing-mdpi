load("../../data/testing/testingData.mat")

baseDir = "../../results/changepoint-results/";
load(baseDir + "rowResultsOriginal_matlab.mat");
[rowOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"MatRowOrig");
load(baseDir + "colResultsOriginal_matlab.mat");
[colOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"MatColOrig");
load(baseDir + "bothResultsOriginal_matlab.mat");
[bothOriginalMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"MatBothOrig");

load(baseDir + "rowResultsSparse_matlab.mat");
[rowOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"MatRowSpar");
load(baseDir + "colResultsSparse_matlab.mat");
[colOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"MatColSpar");
load(baseDir + "bothResultsSparse_matlab.mat");
[bothOriginalGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"MatBothSpar");

load(baseDir + "rowResultsOriginal_gfpop.mat");
[rowSparseMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"GfpopRowOrig");
load(baseDir + "colResultsOriginal_gfpop.mat");
[colSparseMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"GfpopColOrig");
load(baseDir + "bothResultsOriginal_gfpop.mat");
[bothSparseMat,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"GfpopBothOrig");

load(baseDir + "rowResultsSparse_gfpop.mat");
[rowSparseGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"GfpopRowSpar");
load(baseDir + "colResultsSparse_gfpop.mat");
[colSparseGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"GfpopColSpar");
load(baseDir + "bothResultsSparse_gfpop.mat");
[bothSparseGfpop,~,~] = analyzeResults(logical(results{1,1}(:,2)),testingImgLabels,"GfpopBothSpar");
