% SPDX-License-Identifier: BSD-3-Clause

%% Load in the data
beehiveDataSetup;

load(trainingDataDir + filesep + "trainingFeatures","trainingFeatures");
load(trainingDataDir + filesep + "trainingData","trainingRowLabels");


features = vertcat(trainingFeatures{:});
labels = vertcat(trainingRowLabels{:});

%% Select which features to plot
featureNames = ["Skewness", "WaveletAvgRowSkewness", "Kurtosis"];

featuresToPlot = [];

for featureName = featureNames
    featuresToPlot = [featuresToPlot, features.(featureName)];
end


%% Plot properties
fontSize = 9;
fontName = "Tex Gyre Pagella";

colors = colororder(brewermap([],'paired'));
blue = colors(2,:);
red = colors(7,:);

markers = "od";
markerSizes = [3 3];

group = categorical(labels,unique(labels),["No Bee", "Bee"]);

%% Plot
% close all

fig = figure('Units', 'centimeter', 'Position', [2 2 13.86 13.86]);

[h,ax,bigax] = gplotmatrix(featuresToPlot,[],group,[blue;red],markers,markerSizes,[],'grpbars',featureNames);

set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)

% fig.Visible = 'off';

%%
exportgraphics(fig, 'figures/pairwiseScatter.pdf', 'ContentType', 'vector')
