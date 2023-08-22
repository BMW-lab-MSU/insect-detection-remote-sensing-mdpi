% SPDX-License-Identifier: BSD-3-Clause

% Data path setup
beehiveDataSetup;


%% Data Loading
original = load(combinedDataDir + filesep + "2022-06-combined");

%%
imageNum = 820;

% Time Settings
t = juneMetadata(imageNum).Timestamps * 1e3;

% Range Settings
range = juneMetadata(imageNum).Range;

img = juneData{imageNum};


%% Figure settings
fontSize = 10;
fontName = "TeX Gyre Pagella";
lineWidth = 1.75;

%% 
close all;

mainFig = figure('Units','centimeter','Position',[1,1,18.46,13]);
mainLayout = tiledlayout(6,2);

%% Create the 2D image
% imageFig = figure('Units','inches','Position',[3,3,3.5,2]);

nexttile(mainLayout,2,[3,1])
imagesc(t, range, img,[-0.15,-0.01]);
yticks([40 80 120])
colormap(flipud(brewermap([],'blues')))

% colorbar
% xlabel('ms')
% ylabel('range bin')
set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)

%%
insect1RangeBin = 28;
insect2RangeBin = 32;
hardTargetRangeBin = 132;

%% Time domain plots
% timeDomainFig = figure('Units','inches','Position',[3,3,3.5,2]);
colors = colororder(brewermap([],'paired'));

% timeDomainFigLayout = tiledlayout(3,1);

ylims = [-0.6, 0];

nexttile(7)
plot(t, img(hardTargetRangeBin,:),'LineWidth',lineWidth,'Color',colors(7,:))
set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)
ylim(ylims)

nexttile(9)
plot(t, img(insect1RangeBin,:),'LineWidth',lineWidth,'Color',colors(8,:))
set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)
ylim(ylims)


nexttile(11)
plot(t, img(insect2RangeBin,:),'LineWidth',lineWidth,'Color',colors(6,:))
set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)
ylim(ylims)


% timeDomainFigLayout.TileSpacing = 'tight';
% timeDomainFigLayout.Padding = 'tight';
% timeDomainFigLayout.Children(3).XTickLabels = [];
% timeDomainFigLayout.Children(2).XTickLabel = [];
% ylabel(timeDomainFigLayout,'Volts','FontSize',9,'FontName','Times New Roman')
% xlabel(timeDomainFigLayout,'Time','FontSize',9,'FontName','Times New Roman')


%% frequency domain plots
Ts = mean(diff(t))/1000;
Fs = 1/Ts;
f = linspace(0,Fs/2,numel(t));

insect1Spectrum = abs(fft(img(insect1RangeBin,:))).^2;
insect2Spectrum = abs(fft(img(insect2RangeBin,:))).^2;
hardTargetSpectrum = abs(fft(img(hardTargetRangeBin,:))).^2;

% freqDomainFig = figure('Units','inches','Position',[3,3,3.5,2]);
% freqDomainFigLayout = tiledlayout(3,1);

nexttile(8)
plot(f(1:500), hardTargetSpectrum(1:500),'LineWidth',lineWidth, 'Color',colors(7,:))
ylim([0 30])
xlim([0 1000])
set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)
yticks([0 10 20])

nexttile(10)
plot(f(1:500), insect1Spectrum(1:500),'LineWidth',lineWidth,'Color',colors(8,:))
ylim([0 130])
xlim([0 1000])
set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)
yticks([0 50 100])


nexttile(12)
plot(f(1:500), insect2Spectrum(1:500),'LineWidth',lineWidth,'Color',colors(6,:))
ylim([0 30])
xlim([0 1000])
set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)
yticks([0 10 20])


% 
% freqDomainFigLayout.TileSpacing = 'tight';
% freqDomainFigLayout.Padding = 'tight';
% freqDomainFigLayout.Children(3).XTickLabels = [];
% freqDomainFigLayout.Children(2).XTickLabel = [];

% xlabel(freqDomainFigLayout,'Frequency','FontSize',9,'FontName','Times New Roman')


%%
mainLayout.TileSpacing = 'compact';
mainLayout.Padding = 'compact';
mainLayout.Children(2).XTickLabel = [];
mainLayout.Children(3).XTickLabel = [];
mainLayout.Children(5).XTickLabel = [];
mainLayout.Children(6).XTickLabel = [];





%%
% exportgraphics(imageFig, 'insectImage.pdf','ContentType','vector')
% exportgraphics(timeDomainFig, 'timeDomainExamples.pdf','ContentType','vector')
% exportgraphics(freqDomainFig, 'freqDomainExamples.pdf','ContentType','vector')
exportgraphics(mainFig, 'figures/insectExampleIntuition.pdf', 'ContentType','vector')