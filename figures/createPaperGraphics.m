% Generate the plots for the MDPI journal paper.
% Plot 1: Four examples of bees (body, wings, blips, hard target)
% Plot 2: Transit and Frequency Histograms

% Example Bees Figures
%   Body: 06/24-095001-193
%   Wings: 06/24-095001-221
%   Blip: 06/24-095001-154
%   Hard Target: 06/24-111746-32
clear;

% Data Loading

bodyImgNum = 193;
wingImgNum = 221;
blipImgNum = 154;
hardImgNum = 32;

load("../../data/raw/2022-06-24/MSU-horticulture-farm-bees-095001/adjusted_data_junecal_volts.mat");
bodyImg = adjusted_data_junecal(bodyImgNum).data;
wingImg = adjusted_data_junecal(wingImgNum).data;
blipImg = adjusted_data_junecal(blipImgNum).data;
imgTime = adjusted_data_junecal(blipImgNum).time;

load("../../data/raw/2022-06-24/MSU-horticulture-farm-bees-111746/adjusted_data_junecal_volts.mat");
hardImg = adjusted_data_junecal(hardImgNum).data;
clear adjusted_data_junecal;
%%

% Display Settings
rowStop = 60;
colStop = 1024;

% Font Settings
imgFontName = "Times New Roman";
imgFontSize = 10;

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
fig1 = figure(1);
t1 = tiledlayout(fig1,2,2,"TileSpacing","tight","Padding","compact");
t1.XLabel.String = "Time [ms]";
t1.XLabel.FontName = imgFontName;
t1.XLabel.FontSize = imgFontSize;
t1.YLabel.String = "Range [m]";
t1.YLabel.FontName = imgFontName;
t1.YLabel.FontSize = imgFontSize;

% Body Settings
p1 = nexttile;
imagesc(time,range(1:rowStop),bodyImg(1:rowStop,1:colStop),[-.4 .1]); title("Body Example");
p1.FontName = imgFontName; p1.FontSize = imgFontSize;
p1.XTickMode = "manual";

% Wing Settings
p2 = nexttile;
imagesc(time,range(1:rowStop),wingImg(1:rowStop,1:colStop),[-.4 .1]); title("Wings Example");
p2.FontName = imgFontName; p2.FontSize = imgFontSize;
p2.XTickMode = "manual";
p2.YTickMode = "manual";

% Blip Settings
p3 = nexttile;
imagesc(time,range(1:rowStop),blipImg(1:rowStop,1:colStop),[-.4 .1]); title("Blip Example");
p3.FontName = imgFontName; p3.FontSize = imgFontSize;

% Hard Target Settings
p4 = nexttile;
imagesc(time,range(1:rowStop),hardImg(1:rowStop,1:colStop),[-.4 .1]); title("Hard Target w/ Bees");
p4.FontName = imgFontName; p4.FontSize = imgFontSize;
p4.YTickMode = "manual";

% Colorbar
cbar = colorbar;
cbar.Layout.Tile = 'east';
cbar.YDir = 'reverse';
cbar.Label.String = 'PMT voltage (V)';
cbar.Label.FontSize = 11;
cbar.Label.FontName = 'Times New Roman';
cbar.FontSize = 10;
cbar.FontName = 'Times New Roman';

% Colormap
cmap = colormap(brewermap([],'Blues'));
colormap(flipud(cmap));

exportgraphics(fig1,"beeExamples.pdf","ContentType","vector");

%%
% Transit Time and Frequency Histograms

% Load Data
load("../../code/transit-frequency-analysis/beeHarmonicEstimateCount.mat");
load("../../code/transit-frequency-analysis/beeTransitTimes.mat")

% General Variables
faceColor = [0 .5 1];
faceAlpha = .3;
edgeColor = [0 .5 1];
edgeAlpha = .15;

% Figure and Layout Settings
fig2 = figure(2); clf;
t2 = tiledlayout(fig2,1,2,"TileSpacing","tight","Padding","compact");
t2.Title.String = "Transit Time and Harmonic Frequency Histogram"; t2.Title.FontName = imgFontName;
t2.YLabel.String = "Count"; t2.YLabel.FontName = imgFontName; t2.YLabel.FontSize = imgFontSize;

% Transit Time Settings
p5 = nexttile; hold on;
p5.FontName = imgFontName; p5.FontSize = imgFontSize; 
p5.YLabel.String = "Bee Count";
p5.XLabel.String = "Transit Time [ms]"; 
p5.XLim = [0 .31];
h1 = histogram(transitTimes); h1.EdgeColor = edgeColor; h1.FaceColor = faceColor; h1.EdgeAlpha = edgeAlpha; h1.FaceAlpha = faceAlpha;

% Harmonics Settings
p6 = nexttile; hold on;
p6.FontName = imgFontName; p6.FontSize = imgFontSize;
p6.YLabel.String = "Row Count";
p6.XLabel.String = "Estimated Harmonic Frequency [Hz]";
p6.YLim = [0 1250];
p6.XLim = [61 900];
h2 = histogram(totalHarmonicCount); h2.EdgeColor = edgeColor; h2.FaceColor = faceColor; h2.EdgeAlpha = edgeAlpha; h2.FaceAlpha = faceAlpha;

exportgraphics(fig2,"transitHarmonicHistograms.pdf","ContentType","vector");
