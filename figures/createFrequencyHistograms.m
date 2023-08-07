% SPDX-License-Identifier: BSD-3-Clause

%% Set up data
beehiveDataSetup;

load(trainingDataDir + filesep + "trainingFeatures","trainingFeatures");
load(trainingDataDir + filesep + "trainingData","trainingRowLabels");


features = vertcat(trainingFeatures{:});
labels = vertcat(trainingRowLabels{:});

beeFeatures = features(labels == true,:);
nonbeeFeatures = features(labels == false,:);

beeFreq1 = beeFeatures.HarmonicFreq1;
beeFreq2 = beeFeatures.HarmonicFreq2;
beeFreq3 = beeFeatures.HarmonicFreq3;

nonbeeFreq1 = nonbeeFeatures.HarmonicFreq1;
nonbeeFreq2 = nonbeeFeatures.HarmonicFreq2;
nonbeeFreq3 = nonbeeFeatures.HarmonicFreq3;

%% Plot settings

fontSize = 9;
fontName = "Tex Gyre Pagella";

colors = colororder(brewermap([],'paired'));
blue = colors(2,:);
yellow = colors(7,:);

%%
close all;

fig = figure('Units', 'centimeter', 'Position', [2 2 13.86 8]);

tlayout = tiledlayout(1,3);

nexttile

histogram(nonbeeFreq1,70,FaceColor=blue,EdgeAlpha=0.2,EdgeColor=blue,Normalization="pdf")
hold on
histogram(beeFreq1,70,FaceColor=yellow,EdgeAlpha=0.2,EdgeColor=yellow,Normalization="pdf")
hold off

box off

xticks([0,200,400])

ylims = ylim();
yticks([0,ylims(2)])

title('(a)')

set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)

nexttile

histogram(nonbeeFreq2,70,FaceColor=blue,EdgeAlpha=0.2,EdgeColor=blue,Normalization="pdf")
hold on
histogram(beeFreq2,70,FaceColor=yellow,EdgeAlpha=0.2,EdgeColor=yellow,Normalization="pdf")
hold off

box off

title('(b)')

xticks([0,400,800])
ylims = ylim();
yticks([0,ylims(2)])

set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)

nexttile

histogram(nonbeeFreq3,70,FaceColor=blue,EdgeAlpha=0.2,EdgeColor=blue,Normalization="pdf")
hold on
histogram(beeFreq3,70,FaceColor=yellow,EdgeAlpha=0.2,EdgeColor=yellow,Normalization="pdf")
hold off

box off

xticks([0,600,1200])
ylims = ylim();
yticks([0,ylims(2)])

legend(["No bee", "Bee"],"FontSize",fontSize,"FontName",fontName)

title('(c)')


set(gca, 'FontSize', fontSize)
set(gca, 'FontName', fontName)

tlayout.XLabel.String = "Frequency (Hz)";
tlayout.XLabel.FontName = fontName;
tlayout.XLabel.FontSize = fontSize;

tlayout.YLabel.String = "Probability density";
tlayout.YLabel.FontName = fontName;
tlayout.YLabel.FontSize = fontSize;

tlayout.Padding = "tight";
tlayout.TileSpacing = "compact";


%%
exportgraphics(fig, 'figures/frequencyFeatureHistograms.pdf', 'ContentType', 'vector')
