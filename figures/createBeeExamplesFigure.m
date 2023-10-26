clear;

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

load(rawDataDir + filesep + "2022-06-24" + filesep +"MSU-horticulture-farm-bees-095001" + filesep + "adjusted_data_junecal_volts.mat");
bodyImg = adjusted_data_junecal(bodyImgNum).data;
bodyImgRange = adjusted_data_junecal(bodyImgNum).range;
bodyImgTime = adjusted_data_junecal(bodyImgNum).time;

wingImg = adjusted_data_junecal(wingImgNum).data;
wingImgRange = adjusted_data_junecal(wingImgNum).range;
wingImgTime = adjusted_data_junecal(wingImgNum).time;

load(rawDataDir + filesep + "2022-06-24" + filesep +"MSU-horticulture-farm-bees-104012" + filesep + "adjusted_data_junecal_volts.mat");
% load("../../data/raw/2022-06-24/MSU-horticulture-farm-bees-104012/adjusted_data_junecal_volts.mat");
blipImg = adjusted_data_junecal(blipImgNum).data;
blipImgRange = adjusted_data_junecal(blipImgNum).range;
blipImgTime = adjusted_data_junecal(blipImgNum).time;

load(rawDataDir + filesep + "2022-06-24" + filesep +"MSU-horticulture-farm-bees-111746" + filesep + "adjusted_data_junecal_volts.mat");
% load("../../data/raw/2022-06-24/MSU-horticulture-farm-bees-111746/adjusted_data_junecal_volts.mat");
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

exportgraphics(fig1,"figures/beeExamples.pdf","ContentType","vector");
