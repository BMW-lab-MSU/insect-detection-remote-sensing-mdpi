% SPDX-License-Identifier: BSD-3-Clause
clear;

% Data path setup
beehiveDataSetup;


%% Data Loading

original = load(combinedDataDir + filesep + "2022-06-combined");
thresholded = load(preprocessedDataDir + filesep + "2022-06-preprocessed");

%%
imageNum = 889;

ogImage = original.juneData{imageNum};
thresholdedImage = thresholded.juneData{imageNum};

%%

% Display Settings
rowStop = 60;
colStop = 1024;

% Font Settings
imgFontName = "TeX Gyre Pagella";
imgFontSize = 10;

% Time Settings
t = original.juneMetadata(imageNum).Timestamps * 1e3;

% Range Settings
range = original.juneMetadata(imageNum).Range;



%%

% Figure and Layout Settings
figSize = [13.86, 7];

fig1 = figure("Units","centimeters",Position=[1 1 figSize(1) figSize(2)]);
t1 = tiledlayout(fig1,1,2,"TileSpacing","tight","Padding","compact");
t1.XLabel.String = "Time (ms)";
t1.XLabel.FontName = imgFontName;
t1.XLabel.FontSize = imgFontSize;
t1.YLabel.String = "Range (m)";
t1.YLabel.FontName = imgFontName;
t1.YLabel.FontSize = imgFontSize;

colorLims = [-0.2, 0.1];

% Body Settings
p1 = nexttile;
imagesc(t,range(1:rowStop),ogImage(1:rowStop,1:colStop),colorLims); 
p1.FontName = imgFontName; p1.FontSize = imgFontSize;
title('(a)', 'Units', 'normalized', 'FontSize', 11)
% p1.XTickMode = "manual";

% Wing Settings
p2 = nexttile;
imagesc(t,range(1:rowStop),thresholdedImage(1:rowStop,1:colStop),colorLims);
p2.FontName = imgFontName; p2.FontSize = imgFontSize;
title('(b)', 'Units', 'normalized', 'FontSize', 11)

% p2.XTickMode = "manual";
p2.YTickMode = "manual";
yticks([])


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
colors = colormap(brewermap([],'Paired'));
red = colors(6,:);

cmap = colormap(brewermap([],'Blues'));
colormap(flipud(cmap));


% Rectangle Annotations
annotation(fig1,'rectangle',[0.09 0.51 0.045 0.087],'Color',red,'LineWidth',1.25);
annotation(fig1,'rectangle',[0.316 0.53 0.076 0.087],'Color',red,'LineWidth',1.25);
annotation(fig1,'rectangle',[0.465 0.51 0.0459 0.087],'Color',red,'LineWidth',1.25);
annotation(fig1,'rectangle',[0.684 0.53 0.076 0.087],'Color',red,'LineWidth',1.25);

exportgraphics(fig1,"figures/thresholdingExample.pdf","ContentType","vector");
