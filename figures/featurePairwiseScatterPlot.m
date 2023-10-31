% SPDX-License-Identifier: BSD-3-Clause

%% Load in the data
beehiveDataSetup;

load(trainingDataDir + filesep + "trainingFeatures","trainingFeatures");
load(trainingDataDir + filesep + "trainingData","trainingRowLabels");


features = vertcat(trainingFeatures{:});
labels = vertcat(trainingRowLabels{:});

%% Select which features to plot
featureNames = ["Skewness", "WaveletAvgSkewness", "Kurtosis"];

featuresToPlot = [];

for featureName = featureNames
    featuresToPlot = [featuresToPlot, features.(featureName)];
end


%% Plot properties
fontSize = 9;
fontName = "Tex Gyre Pagella";

colors = colororder(brewermap([],'paired'));
blue = colors(2,:);
yellow = colors(7,:);

markers = "sd";
markerSizes = [4.5 4.5];

group = categorical(labels,unique(labels),["No Bee", "Bee"]);

%% Plot
% close all

fig = figure('Units', 'centimeter', 'Position', [2 2 13.86 13.86]);

[h,ax,bigax] = gplotmatrix(featuresToPlot,[],group,[blue;yellow],markers,markerSizes,[],'grpbars',featureNames);

% Make legend invisible
legendobj = ax(1,3).Legend;
set(legendobj.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;0]));
set(legendobj.BoxEdge, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;0]));

set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)

% fig.Visible = 'off';

%%
exportgraphics(fig, 'figures/pairwiseScatter.pdf', 'ContentType', 'vector')
