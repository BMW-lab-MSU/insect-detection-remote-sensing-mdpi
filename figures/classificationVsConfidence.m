% SPDX-License-Identifier: BSD-3-Clause
fontName = 'Tex Gyre Pagella';
fontSize = 10;
figWidthFullPage = 18.46;

beehiveDataSetup;

classifiers = ["RUSBoost","AdaBoost","LinearSVM","StatsNeuralNetwork1Layer",...
    "StatsNeuralNetwork3Layer","StatsNeuralNetwork5Layer",...
    "StatsNeuralNetwork7Layer","CNN1d1Layer","CNN1d3Layer","CNN1d5Layer",...
    "CNN1d7Layer"];

changepointMethods = ["gfpopRows","matlabChptsRows","gfpopCols","matlabChptsCols",...
    "gfpopBoth","matlabChptsBoth"];

methodNames = [classifiers, changepointMethods];

nMethods = numel(methodNames);
confidenceLevels = 1:4;

load(testingResultsDir + filesep + "confidenceRatingEffects.mat","confidenceMetrics")

pctCorrect = zeros(nMethods,numel(confidenceLevels));
for i = 1:nMethods
    pctCorrect(i,:) = mean(vertcat(confidenceMetrics(methodNames(i)).Confidence.PctCorrect),2);
end

displayNames = ["RUSBoost","AdaBoost","SVM","MLP 1",...
    "MLP 3","MLP 5",...
    "MLP 7","1D CNN 1","1D CNN 3","1D CNN 5",...
    "1D CNN 7","gfpop Rows","Matlab Rows","gfpop Cols","Matlab Cols",...
    "gfpop Both","Matlab Both"];
x = reordercats(categorical(displayNames),displayNames);

close all;
h = figure('Units','centimeters','Position',[1,1,figWidthFullPage,7]);
bar(x,pctCorrect,LineStyle='none',BarWidth=1)
legendObj = legend(["confidence = 1", "confidence = 2", "confidence = 3", "confidence = 4"]);

legendObj.Box='off';
legendObj.Location='northoutside';
legendObj.Orientation='horizontal';

box off

ylabel("Recall")

set(gca,'FontName',fontName,'FontSize',fontSize)

colors = brewermap(6,'blues');
colororder(colors(2:5,:));

exportgraphics(h, "figures/recallVsConfidence.pdf")
