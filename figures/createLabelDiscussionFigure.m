clear;

% Data path setup
beehiveDataSetup;

%% Data Loading
load(testingDataDir + filesep + "testingData");

load(testingResultsDir + filesep + "StatsNeuralNetwork3LayerResults");

%% Convert row results back into cell arrays for each image
N_ROWS = 178;
nImages = numel(testingData);

predictedLabels = mat2cell(results.Row.PredictedLabels, N_ROWS * ones(1,nImages),1);
trueLabels = mat2cell(results.Row.TrueLabels, N_ROWS * ones(1,nImages),1);

%% Select images
% One image has more predicted insect rows than actual insects rows, and the
% other iamge has more true insect rows than predicted rows. The insect was
% correctly identified in both images.
morePredictedRowsImageNum = 61;
moreTrueRowsImageNum = 2573;

tMorePredicted = 1e3 * testingMetadata(morePredictedRowsImageNum).Timestamps;
tMoreTrue = 1e3 * testingMetadata(moreTrueRowsImageNum).Timestamps;

rangeMorePredicted = testingMetadata(morePredictedRowsImageNum).Range;
rangeMoreTrue = testingMetadata(moreTrueRowsImageNum).Range;

imgMorePredicted = testingData{morePredictedRowsImageNum};
imgMoreTrue = testingData{moreTrueRowsImageNum};

predictedLabelsMorePredicted = predictedLabels{morePredictedRowsImageNum};
trueLabelsMorePredicted = trueLabels{morePredictedRowsImageNum};
predictedLabelsMoreTrue = predictedLabels{moreTrueRowsImageNum};
trueLabelsMoreTrue = trueLabels{moreTrueRowsImageNum};

%% Figure settigns
fontSize = 10;
fontName = "TeX Gyre Pagella";

cmap = flipud(brewermap([],'blues'));

% use light and dark orange for the label colors
colors = colororder(brewermap([],'paired'));
labelColors = colors([7,8],:);

% truncate range to make the important rows easier to see / larger
rowStop = 50;

figSize = [18.46, 7];


%% Create figure to hold both plots
close all;

fig = figure("Units","centimeters",Position=[1 1 figSize(1) figSize(2)]);

mainLayout = tiledlayout(fig,1,2,"TileSpacing","tight","Padding","compact");

%% Create the subfigures
figure(2)
tLayoutMorePredicted = labelComparisonFig(...
    trueLabelsMorePredicted(1:rowStop),...
    predictedLabelsMorePredicted(1:rowStop),...
    imgMorePredicted(1:rowStop,:),tMorePredicted,...
    rangeMorePredicted(1:rowStop),...
    DataColormap=cmap,LabelColors=labelColors,...
    FontSize=fontSize,FontName=fontName);

figure(3)
tLayoutMoreTrue = labelComparisonFig(...
    trueLabelsMoreTrue(1:rowStop),...
    predictedLabelsMoreTrue(1:rowStop),...
    imgMoreTrue(1:rowStop,:),tMoreTrue,...
    rangeMoreTrue(1:rowStop),...
    DataColormap=cmap,LabelColors=labelColors,...
    FontSize=fontSize,FontName=fontName);

%% Assign the subfigures to the main tiledlayout
tLayoutMorePredicted.Parent = mainLayout;
tLayoutMorePredicted.Layout.Tile = 1;

tLayoutMoreTrue.Parent = mainLayout;
tLayoutMoreTrue.Layout.Tile = 2;

close(2);
close(3);

%% Setup axis labels, etc.

% remove y-axis labels for the second subfigure
mainLayout.Children(1).Children(3).YTick = [];

% set axis labels
mainLayout.XLabel.String = "Time (ms)";
mainLayout.XLabel.FontName = fontName;
mainLayout.XLabel.FontSize = fontSize;
mainLayout.YLabel.String = "Range (m)";
mainLayout.YLabel.FontName = fontName;
mainLayout.YLabel.FontSize = fontSize;

% set subfigure titles
mainLayout.Children(2).Title.String = "(a)";
mainLayout.Children(2).Title.FontName = fontName;
mainLayout.Children(2).Title.FontSize = fontSize;
mainLayout.Children(2).Title.FontWeight = "bold";

mainLayout.Children(1).Title.String = "(b)";
mainLayout.Children(1).Title.FontName = fontName;
mainLayout.Children(1).Title.FontSize = fontSize;
mainLayout.Children(1).Title.FontWeight = "bold";

% Colorbar
cbar = colorbar(mainLayout.Children(1).Children(3));
cbar.Layout.Tile = 'east';
cbar.YDir = 'reverse';
cbar.Label.String = 'PMT voltage (V)';
cbar.Label.FontSize = fontSize;
cbar.Label.FontName = fontName;
cbar.FontSize = fontSize;
cbar.FontName = fontName;

%% Export figure
exportgraphics(fig,"figures/testingLabelExamples.pdf","ContentType","vector");
