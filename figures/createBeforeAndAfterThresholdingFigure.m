% Generate the plots for the MDPI journal paper.
% Plot 1: Four examples of bees (body, wings, blips, hard target)
% Plot 2: Transit and Frequency Histograms

% Example Bees Figures
%   Body: 06/24-095001-193
%   Wings: 06/24-095001-221
%   Blip: 06/24-095001-154
%   Hard Target: 06/24-111746-32
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
rowStop = 178;
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
figSize = [18.46, 7];

fig1 = figure("Units","centimeters",Position=[1 1 figSize(1) figSize(2)]);
t1 = tiledlayout(fig1,1,2,"TileSpacing","tight","Padding","compact");
t1.XLabel.String = "Time (ms)";
t1.XLabel.FontName = imgFontName;
t1.XLabel.FontSize = imgFontSize;
t1.YLabel.String = "Range (m)";
t1.YLabel.FontName = imgFontName;
t1.YLabel.FontSize = imgFontSize;

colorLims = [min(ogImage,[],"all"), max(ogImage,[],"all")];

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
cmap = colormap(brewermap([],'Blues'));
colormap(flipud(cmap));

exportgraphics(fig1,"figures/thresholdingExample.pdf","ContentType","vector");


