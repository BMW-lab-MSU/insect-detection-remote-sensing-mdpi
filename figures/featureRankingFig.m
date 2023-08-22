% SPDX-License-Identifier: BSD-3-Clause
%%
beehiveDataSetup;

load(trainingDataDir + filesep + "trainingFeatures","trainingFeatures");

%%
features = vertcat(trainingFeatures{:});

nFeatures = width(features);

mi = table2array(readtable(featureAnalysisResultsDir + filesep + 'mi.csv'));

featureNames = string(features.Properties.VariableNames);

%%
close all;
fontSize = 8;
fontName = "Tex Gyre Pagella";

colors = colororder(brewermap([],'paired'));
blue = colors(2,:);

fig = figure('Units', 'centimeter', 'Position', [2 2 18.46 22]);

sortedBar(mi,featureNames,ShowValuesInBars=false,FaceColor=blue,...
    LabelFontSize=fontSize,FontName=fontName);

xlabel('Importance')

set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)

%%
exportgraphics(fig, 'figures/featureRanking.pdf', 'ContentType', 'vector')
