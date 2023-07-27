% SPDX-License-Identifier: BSD-3-Clause
%%
beehiveDataSetup;

load(trainingDataDir + filesep + "trainingFeatures","trainingFeatures");
load(trainingDataDir + filesep + "trainingData","trainingRowLabels");


features = vertcat(trainingFeatures{:});
labels = vertcat(trainingRowLabels{:});

%%
close all;
[idx, scores] = fscmrmr(features, labels);

%%
fontSize = 10;
fontName = "Tex Gyre Pagella";

colors = colororder(brewermap([],'dark2'));

fig = figure('Units', 'centimeter', 'Position', [2 2 18.46 20]);

bar(scores(idx),0.7,'FaceColor',colors(1,:),'Horizontal',true);
xlabel('Importance')
yticks(1:numel(idx))
yticklabels(features.Properties.VariableNames(idx))
% xtickangle(45)
set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)

% fig.Visible = 'off';

%%
exportgraphics(fig, 'figures/featureRanking.pdf', 'ContentType', 'vector')
