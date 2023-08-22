% Generate the plots for the MDPI journal paper.
% Plot 1: Four examples of bees (body, wings, blips, hard target)
% Plot 2: Transit and Frequency Histograms

clear figures;








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

%% Figure 1 : Example Bee Images
%% Load data

% Example Bees Figures
%   Body: 06/24-095001-193
%   Wings: 06/24-095001-221
%   Blip: 06/24-095001-154
%   Hard Target: 06/24-111746-32
bodyImgNum = 193;
wingImgNum = 221;
blipImgNum = 105;
hardImgNum = 32;

load("../../data/raw/2022-06-24/MSU-horticulture-farm-bees-095001/adjusted_data_junecal_volts.mat");
bodyImg = adjusted_data_junecal(bodyImgNum).data;
bodyImgRange = adjusted_data_junecal(bodyImgNum).range;
bodyImgTime = adjusted_data_junecal(bodyImgNum).time;

wingImg = adjusted_data_junecal(wingImgNum).data;
wingImgRange = adjusted_data_junecal(wingImgNum).range;
wingImgTime = adjusted_data_junecal(wingImgNum).time;

load("../../data/raw/2022-06-24/MSU-horticulture-farm-bees-104012/adjusted_data_junecal_volts.mat");
blipImg = adjusted_data_junecal(blipImgNum).data;
blipImgRange = adjusted_data_junecal(blipImgNum).range;
blipImgTime = adjusted_data_junecal(blipImgNum).time;

load("../../data/raw/2022-06-24/MSU-horticulture-farm-bees-111746/adjusted_data_junecal_volts.mat");
hardImg = adjusted_data_junecal(hardImgNum).data;
hardImgRange = adjusted_data_junecal(hardImgNum).range;
hardImgTime = adjusted_data_junecal(hardImgNum).time;

clear adjusted_data_junecal;


%% Create figure
% Display Settings
rowStart = 10;
rowStop = 50;
colStop = 900;

% Time Settings
SEC_TO_MS = 1e3;

% Color limits
clims = [-0.125, 0];

% Figure and Layout Settings
fig1 = figure("Units","centimeters","Position",[1 1 figWidthFullPage 11]);
hold on;
t1 = tiledlayout(fig1,2,2,"TileSpacing","compact","Padding","tight");

% Body Settings
p1 = nexttile;
imagesc(bodyImgTime(1:colStop) * SEC_TO_MS,bodyImgRange(rowStart:rowStop),bodyImg(rowStart:rowStop,1:colStop),clims); 
title("(a)","FontWeight","bold","FontName",fontName,"FontSize",fontSize);
p1.FontName = fontName; p1.FontSize = fontSize;
% p1.XTickMode = "manual";
p1.XTick = [0 100 200 300];


% Wing Settings
p2 = nexttile;
imagesc(wingImgTime(1:colStop) * SEC_TO_MS,wingImgRange(rowStart:rowStop),wingImg(rowStart:rowStop,1:colStop),clims);
title("(b)","FontWeight","bold","FontName",fontName,"FontSize",fontSize);
p2.FontName = fontName; p2.FontSize = fontSize;
% p2.XTickMode = "manual";
% p2.YTickMode = "manual";
p2.XTick = [0 100 200 300];


% Blip Settings
blipRowStart = 30;
blipRowStop = 79;
p3 = nexttile;
imagesc(blipImgTime(1:colStop) * SEC_TO_MS,blipImgRange(blipRowStart:blipRowStop),blipImg(blipRowStart:blipRowStop,1:colStop),clims);
title("(c)","FontWeight","bold","FontName",fontName,"FontSize",fontSize);
p3.FontName = fontName; p3.FontSize = fontSize;
p3.YTick = [50 60 70];
p3.XTick = [0 100 200 300];

% Hard Target Settings
p4 = nexttile;
imagesc(hardImgTime(1:colStop) * SEC_TO_MS,hardImgRange(rowStart:rowStop),hardImg(rowStart:rowStop,1:colStop),clims);
title("(d)","FontWeight","bold","FontName",fontName,"FontSize",fontSize);
p4.FontName = fontName; p4.FontSize = fontSize;
% p4.YTickMode = "manual";
p4.YTick = [30 40 50];
p4.XTick = [0 100 200];


% Colorbar
cbar = colorbar;
cbar.Layout.Tile = 'east';
cbar.YDir = 'reverse';
cbar.Label.String = 'PMT voltage (V)';
cbar.Label.FontSize = fontSize;
cbar.Label.FontName = fontName;
cbar.FontSize = fontSize;
cbar.FontName = fontName;

% Set colormap
colormap(cmap)

% Rectangle a
annotation(fig1,'rectangle',[0.145 0.74 0.06 0.04],'Color',red,'LineWidth',1.25);

% Rectangle b1
annotation(fig1,'rectangle',[0.748 0.81 0.0620 0.04],'Color',red,'LineWidth',1.25);

% Rectangle b2
annotation(fig1,'rectangle',[0.627 0.665 0.025 0.04],'Color',red,'LineWidth',1.25);

% Rectangle c1
annotation(fig1,'rectangle',[0.372 0.335 0.03 0.04],'Color',red,'LineWidth',1.25);

% Rectangle c2
annotation(fig1,'rectangle',[0.322 0.14 0.0352 0.04],'Color',red,'LineWidth',1.25);

% Rectangle d1
annotation(fig1,'rectangle',[0.53 0.36 0.0620 0.04],'Color',red,'LineWidth',1.25);

% Rectangle d2
annotation(fig1,'rectangle',[0.585 0.31 0.09 0.04],'Color',red,'LineWidth',1.25);


t1.XLabel.String = "Time (ms)";
t1.XLabel.FontName = fontName;
t1.XLabel.FontSize = fontSize;
t1.YLabel.String = "Range (m)";
t1.YLabel.FontName = fontName;
t1.YLabel.FontSize = fontSize;

exportgraphics(fig1,"beeExamples.pdf","ContentType","vector");

%% Figure 2 : Transit Time and Frequency Histograms

% Transit Time and Frequency Figures
load("../../code/transit-frequency-analysis/CSVInfoWithFrequenciesFiltered.mat");
load("../../code/transit-frequency-analysis/beeTransitTimes.mat")

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
h2 = histogram([inputCSV.beeFreqFiltered]); h2.EdgeColor = edgeColor; h2.FaceColor = faceColor; h2.EdgeAlpha = edgeAlpha; h2.FaceAlpha = faceAlpha;
p6.XLim = [0 p6.XLim(2)];

t2.YLabel.String = "Bee count";
t2.YLabel.FontSize = fontSize;
t2.YLabel.FontName = fontName;

exportgraphics(fig2,"transitFrequenciesHistograms.pdf","ContentType","vector");

hold off;

%% Figure 3 : Ringing thresholding example
%% Load data
% Before and After Figures
%   2022-06-combined-889
beforeImgNum = 889;
load("../../data/combined/2022-06-combined.mat","juneData","juneMetadata");
beforeImg = juneData{beforeImgNum};
beforeImgRange = juneMetadata(beforeImgNum).Range;
beforeImgTime = juneMetadata(beforeImgNum).Timestamps;

load("../../data/preprocessed/2022-06-preprocessed.mat","juneData","juneMetadata");
afterImg = juneData{beforeImgNum};
afterImgRange = juneMetadata(beforeImgNum).Range;
afterImgTime = juneMetadata(beforeImgNum).Timestamps;

clear juneData

%% Plot

% Display Settings
rowStop = 60;
colStop = 1024;

% Time Settings
SEC_TO_MS = 1e3;

% Color limits
clims = [-0.2, 0.1];


fig3 = figure("Units","centimeters",Position=[1 1 figWidthColumn 5]); hold on;
t3 = tiledlayout(fig3,1,2,"TileSpacing","tight","Padding","tight");
t3.XLabel.String = "Time (ms)";
t3.XLabel.FontName = fontName;
t3.XLabel.FontSize = fontSize;
t3.YLabel.String = "Range (m)";
t3.YLabel.FontName = fontName;
t3.YLabel.FontSize = fontSize;

% Body Settings
p7 = nexttile;
imagesc(beforeImgTime,beforeImgRange(1:rowStop),beforeImg(1:rowStop,1:colStop),clims); 
p7.FontName = fontName; p7.FontSize = fontSize;
p7.Title.String = "(a)"; p7.Title.FontWeight = "bold";
p7.Title.FontName = fontName;
p7.Title.FontSize = fontSize;

% Wing Settings
p8 = nexttile;
imagesc(afterImgTime,afterImgRange(1:rowStop),afterImg(1:rowStop,1:colStop),clims);
p8.FontName = fontName; p8.FontSize = fontSize;
p8.Title.String = "(b)"; p8.Title.FontWeight = "bold";
p8.Title.FontName = fontName;
p8.Title.FontSize = fontSize;


% p2.XTickMode = "manual";
p8.YTickMode = "manual";
yticks([])


% Colorbar
cbar = colorbar;
cbar.Layout.Tile = 'east';
cbar.YDir = 'reverse';
cbar.Label.String = 'PMT voltage (V)';
cbar.Label.FontSize = fontSize;
cbar.Label.FontName = fontName;
cbar.FontSize = fontSize;
cbar.FontName = fontName;

% Colormap
colormap(cmap);

% Rectangle Annotations
annotation(fig3,'rectangle',[0.08 0.53 0.045 0.087],'Color',red,'LineWidth',1.25);
annotation(fig3,'rectangle',[0.316 0.55 0.076 0.087],'Color',red,'LineWidth',1.25);
annotation(fig3,'rectangle',[0.46 0.53 0.0459 0.087],'Color',red,'LineWidth',1.25);
annotation(fig3,'rectangle',[0.7 0.55 0.076 0.087],'Color',red,'LineWidth',1.25);

exportgraphics(fig3,"thresholdingExample.pdf","ContentType","vector");

hold off;