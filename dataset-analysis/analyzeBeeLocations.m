function analyzeBeeLocations
% SPDX-License-Identifier: BSD-3-Clause

beehiveDataSetup;

labelTable = readtable(rawDataDir + filesep + "labels.csv");

h = figure;
violinplot(labelTable.startRow,categorical("bee event"));
ylabel('first range bin')

exportgraphics(h,datasetAnalysisResultsDir + filesep + "bee-rows.png")

