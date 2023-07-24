% Generate the plots for the MDPI journal paper.
% Plot 1: Four examples of bees (body, wings, blips, hard target)
% Plot 2: Transit and Frequency Histograms

clear figures;

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
wingImg = adjusted_data_junecal(wingImgNum).data;
imgTime = adjusted_data_junecal(bodyImgNum).time;

load("../../data/raw/2022-06-24/MSU-horticulture-farm-bees-104012/adjusted_data_junecal_volts.mat");
blipImg = adjusted_data_junecal(blipImgNum).data;

load("../../data/raw/2022-06-24/MSU-horticulture-farm-bees-111746/adjusted_data_junecal_volts.mat");
hardImg = adjusted_data_junecal(hardImgNum).data;
clear adjusted_data_junecal;

% Transit Time and Frequency Figures
load("../../code/transit-frequency-analysis/harmonicRowCount.mat");
load("../../code/transit-frequency-analysis/beeTransitTimes.mat")

% Before and After Figures
%   2022-06-combined-889
beforeImgNum = 889;
load("../../data/combined/2022-06-combined.mat","juneData");
beforeImg = juneData{beforeImgNum};

load("../../data/preprocessed/2022-06-preprocessed.mat","juneData");
afterImg = juneData{beforeImgNum};

clear juneData

%% General Paper Settings

% Font Settings
imgFontName = 'Helvetica';
imgFontSize = 12;
figSizeSmall = [18.46 7];
figSizeBig = [1 1];

%% Figure 1 : Example Bee Images


% Display Settings
rowStop = 60;
colStop = 1024;

% Time Settings
SEC_TO_MS = 1e3;
timeStart = 0;
timeEnd = imgTime(end);

% Range Settings
rangeResolution = 0.75; %[m]
motorRange = 10; %[m]
motorRangeBin = floor(motorRange/rangeResolution);
rangeStart = motorRange - rangeResolution * (motorRangeBin - 1);
rangeEnd = rangeStart + rangeResolution * (height(bodyImg) - 1);

% Axis Vectors
range = rangeStart:rangeResolution:rangeEnd;
time = timeStart*1e3:timeEnd*1e3/1024:timeEnd*1e3;

% Figure and Layout Settings
fig1 = figure("Units","centimeters","Position",[1 1 figSizeSmall(1) figSizeSmall(2)]); hold on;
t1 = tiledlayout(fig1,2,2,"TileSpacing","tight","Padding","compact");

% Body Settings
p1 = nexttile;
imagesc(time,range(1:rowStop),bodyImg(1:rowStop,1:colStop),[-.2 .1]); title("(a)","FontWeight","bold");
p1.FontName = imgFontName; p1.FontSize = imgFontSize;
p1.XTickMode = "manual";

% Wing Settings
p2 = nexttile;
imagesc(time,range(1:rowStop),wingImg(1:rowStop,1:colStop),[-.2 .1]); title("(b)","FontWeight","bold");
p2.FontName = imgFontName; p2.FontSize = imgFontSize;
p2.XTickMode = "manual";
p2.YTickMode = "manual";

% Blip Settings
p3 = nexttile;
imagesc(time,range(30:90),blipImg(30:90,1:colStop),[-.2 .1]); title("(c)","FontWeight","bold");
p3.FontName = imgFontName; p3.FontSize = imgFontSize;

% Hard Target Settings
p4 = nexttile;
imagesc(time,range(1:rowStop),hardImg(1:rowStop,1:colStop),[-.2 .1]); title("(d)","FontWeight","bold");
p4.FontName = imgFontName; p4.FontSize = imgFontSize;
p4.YTickMode = "manual";

% Colorbar
cbar = colorbar;
cbar.Layout.Tile = 'east';
cbar.YDir = 'reverse';
cbar.Label.String = 'PMT voltage (V)';
cbar.Label.FontSize = imgFontSize;
cbar.Label.FontName = imgFontName;
cbar.FontSize = imgFontSize;
cbar.FontName = imgFontName;

% Rectangle a
annotation(fig1,'rectangle',[0.141187004564268 0.707500000000003 0.0620642831347056 0.0642559523809532],'Color',[1 0 0]);

% Rectangle b
annotation(fig1,'rectangle',[0.706466775009029 0.749166666666667 0.0620642831347055 0.0642559523809532],'Color',[1 0 0]);

% Rectangle c1
annotation(fig1,'rectangle',[0.353525598538445 0.389318181818185 0.0324141432119143 0.0642559523809532],'Color',[1 0 0]);

% Rectangle c2
annotation(fig1,'rectangle',[0.306179830963122 0.249166666666669 0.0352835836710251 0.0642559523809534],'Color',[1 0 0]);

% Rectangle d1
annotation(fig1,'rectangle',[0.494128181034857 0.374166666666669 0.0620642831347054 0.0642559523809532],'Color',[1 0 0]);

% Rectangle d2
annotation(fig1,'rectangle',[0.577341954349061 0.343863636363639 0.0620642831347054 0.0642559523809532],'Color',[1 0 0]);

% Colormap
cmap = colormap(brewermap([],'Blues'));
colormap(flipud(cmap));

t1.XLabel.String = "Time [ms]";
t1.XLabel.FontName = imgFontName;
t1.XLabel.FontSize = imgFontSize;
t1.YLabel.String = "Range [m]";
t1.YLabel.FontName = imgFontName;
t1.YLabel.FontSize = imgFontSize;

exportgraphics(fig1,"beeExamples.pdf","ContentType","vector");

%% Figure 2 : Transit Time and Frequency Histograms

% General Variables
faceColor = [0 .5 1];
faceAlpha = .3;
edgeColor = [0 .5 1];
edgeAlpha = .15;

% Figure and Layout Settings
fig2 = figure("Units","centimeters","Position",[1 1 figSizeSmall(1) figSizeSmall(2)]); clf; hold on;
t2 = tiledlayout(fig2,1,2,"TileSpacing","tight","Padding","compact");

% Transit Time Settings
p5 = nexttile; hold on;
p5.FontName = imgFontName; p5.FontSize = imgFontSize; 
p5.YLabel.String = "Bee Count";
p5.XLabel.String = "Transit Time [ms]"; 
p5.Title.String = "(a)"; p5.Title.FontWeight = "bold";
h1 = histogram(transitTimes.*1000); h1.EdgeColor = edgeColor; h1.FaceColor = faceColor; h1.EdgeAlpha = edgeAlpha; h1.FaceAlpha = faceAlpha;
p5.XLim = [0 p5.XLim(2)];

% Harmonics Settings
p6 = nexttile; hold on;
p6.FontName = imgFontName; p6.FontSize = imgFontSize;
p6.YLabel.String = "Row Count";
p6.XLabel.String = "Est. Fundamental Frequency [Hz]";
p6.Title.String = "(b)"; p6.Title.FontWeight = "bold";
h2 = histogram(cell2mat(harmonicRowCount)); h2.EdgeColor = edgeColor; h2.FaceColor = faceColor; h2.EdgeAlpha = edgeAlpha; h2.FaceAlpha = faceAlpha;
p6.XLim = [0 p6.XLim(2)];

exportgraphics(fig2,"transitFrequenciesHistograms.pdf","ContentType","vector");

hold off;

%% Figure 3 : Ringing thresholding example

fig3 = figure("Units","centimeters",Position=[1 1 figSizeSmall(1) figSizeSmall(2)]); hold on;
t3 = tiledlayout(fig3,1,2,"TileSpacing","tight","Padding","compact");
t3.XLabel.String = "Time (ms)";
t3.XLabel.FontName = imgFontName;
t3.XLabel.FontSize = imgFontSize;
t3.YLabel.String = "Range (m)";
t3.YLabel.FontName = imgFontName;
t3.YLabel.FontSize = imgFontSize;

% Body Settings
p7 = nexttile;
imagesc(time,range(1:rowStop),beforeImg(1:rowStop,1:colStop),[-.2 .1]); 
p7.FontName = imgFontName; p7.FontSize = imgFontSize;
p7.Title.String = "(a)"; p7.Title.FontWeight = "bold";

% Wing Settings
p8 = nexttile;
imagesc(time,range(1:rowStop),afterImg(1:rowStop,1:colStop),[-.2 .1]);
p8.FontName = imgFontName; p8.FontSize = imgFontSize;
p8.Title.String = "(b)"; p8.Title.FontWeight = "bold";

% p2.XTickMode = "manual";
p8.YTickMode = "manual";
yticks([])


% Colorbar
cbar = colorbar;
cbar.Layout.Tile = 'east';
cbar.YDir = 'reverse';
cbar.Label.String = 'PMT voltage (V)';
cbar.Label.FontSize = imgFontSize;
cbar.Label.FontName = imgFontName;
cbar.FontSize = imgFontSize;
cbar.FontName = imgFontName;

% Colormap
cmap = colormap(brewermap([],'Blues'));
colormap(flipud(cmap));

% Rectangle Annotations
annotation(fig3,'rectangle',[0.0774748923959828 0.500000000000001 0.0459110473457679 0.0871212121212128],'Color',[1 0 0]);
annotation(fig3,'rectangle',[0.316638450502152 0.522727272727273 0.0764748923959827 0.0871212121212126],'Color',[1 0 0]);
annotation(fig3,'rectangle',[0.4743748923959828 0.500000000000001 0.0459110473457679 0.0871212121212128],'Color',[1 .5 0]);
annotation(fig3,'rectangle',[0.716638450502152 0.522727272727273 0.0764748923959827 0.0871212121212126],'Color',[1 .5 0]);

exportgraphics(fig3,"thresholdingExample.pdf","ContentType","vector");

hold off;