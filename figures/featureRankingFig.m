% SPDX-License-Identifier: BSD-3-Clause
%%
beehiveDataSetup;

load(trainingDataDir + filesep + "trainingFeatures","trainingFeatures");
load(trainingDataDir + filesep + "trainingData","trainingRowLabels");

mutualInfo = readmatrix(baseResultsDir + filesep + "feature-analysis" + filesep + "mi.csv");

features = vertcat(trainingFeatures{:});
labels = vertcat(trainingRowLabels{:});

featureNames = string(features.Properties.VariableNames);

%%
% close all;
% [idx, scores] = fscmrmr(features, labels);

%%
close all;
fontSize = 8;
fontName = "Tex Gyre Pagella";

colors = colororder(brewermap([],'paired'));
darkBlue = colors(2,:);

fig = figure('Units', 'centimeter', 'Position', [2 2 18.46 20]);

sortedBar(mutualInfo,featureNames,FaceColor=darkBlue,...
    FontName=fontName,LabelFontSize=fontSize,ShowValuesInBars=false);

% bar(scores(idx),0.7,'FaceColor',colors(1,:),'Horizontal',true);
xlabel('Mutual information')
% yticks(1:numel(idx))
% yticklabels(features.Properties.VariableNames(idx))
% xtickangle(45)
set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)

% fig.Visible = 'off';

%%
exportgraphics(fig, 'figures/featureRanking.pdf', 'ContentType', 'vector')
