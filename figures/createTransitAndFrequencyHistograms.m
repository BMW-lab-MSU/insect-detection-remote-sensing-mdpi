% Generate the plots for the MDPI journal paper.
% Plot 1: Four examples of bees (body, wings, blips, hard target)
% Plot 2: Transit and Frequency Histograms

clear figures;
beehiveDataSetup;

%% General Paper Settings

% Font Settings
fontName = 'Tex Gyre Pagella';
fontSize = 10;
figWidthFullPage = 18.46;
figWidthColumn = 13.86;

% Colormap
cmap = flipud(colormap(brewermap([],'Blues')));

% Accent colors
colors = colormap(brewermap([],'Paired'));
red = colors(6,:);

%% Figure 2 : Transit Time and Frequency Histograms

% Transit Time and Frequency Figures
load(datasetAnalysisResultsDir + filesep + "beeFundamentalFrequencies.mat");
load(datasetAnalysisResultsDir + filesep + "beeTransitTimes.mat")

transitTimes = [beeTransitTimes{:,2}];

% General Variables
faceColor = colors(2,:);
faceAlpha = 1;
edgeColor = colors(1,:);
edgeAlpha = 0.2;

% Figure and Layout Settings
fig2 = figure("Units","centimeters","Position",[1 1 figWidthFullPage 7]); clf; hold on;
t2 = tiledlayout(fig2,1,2,"TileSpacing","tight","Padding","tight");

% Transit Time Settings
p5 = nexttile; hold on;
p5.FontName = fontName; p5.FontSize = fontSize; 
% p5.YLabel.String = "Bee Count";
p5.XLabel.String = "Time (ms)"; 
p5.XLabel.FontSize = fontSize;
p5.XLabel.FontName = fontName;
p5.Title.String = "(a)"; p5.Title.FontWeight = "bold";
h1 = histogram(transitTimes.*1000); h1.EdgeColor = edgeColor; h1.FaceColor = faceColor; h1.EdgeAlpha = edgeAlpha; h1.FaceAlpha = faceAlpha;
p5.XLim = [0 p5.XLim(2)];

% Harmonics Settings
p6 = nexttile; hold on;
p6.FontName = fontName; p6.FontSize = fontSize;
% p6.YLabel.String = "Row Count";
p6.XLabel.String = "Frequency (Hz)";
p6.XLabel.FontSize = fontSize;
p6.XLabel.FontName = fontName;
p6.Title.String = "(b)"; p6.Title.FontWeight = "bold";
h2 = histogram([beeFundamentalFrequencies{:,2}]); h2.EdgeColor = edgeColor; h2.FaceColor = faceColor; h2.EdgeAlpha = edgeAlpha; h2.FaceAlpha = faceAlpha;
p6.XLim = [0 p6.XLim(2)];

t2.YLabel.String = "Bee count";
t2.YLabel.FontSize = fontSize;
t2.YLabel.FontName = fontName;

exportgraphics(fig2,"figures/transitFrequenciesHistograms.pdf","ContentType","vector");
