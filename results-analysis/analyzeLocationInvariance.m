function analyzeLocationInvariance
% CNNs with subsampling, i.e. stride > 1, are not guaranteed to be
% translation-equivariant. This function looks at the results of one
% of the 2D CNNs to see if it predominently missed images where the bess
% were located far away. The vast majority of our images have bees at close
% range bins, due to the beehives being close to the lidar.

beehiveDataSetup;

% The 5 layer 2D CNN had the best recall, so we're looking at that one.
load(testingResultsDir + filesep + "CNN2d3LayerResults.mat");

load(testingDataDir + filesep + "testingData.mat", "testingRowLabels");

wasPredictionCorrect = (results.Image.PredictedLabels)' == (results.Image.TrueLabels);

beeImageIdx = find(results.Image.TrueLabels=='true');

wasBeePredictionCorrect = wasPredictionCorrect(beeImageIdx);

incorrectBeeImagePredictions = beeImageIdx(find(wasBeePredictionCorrect==false))

beeImageRowLabels = testingRowLabels(beeImageIdx);
incorrectBeeImageRowLabels = testingRowLabels(incorrectBeeImagePredictions);

rows = cellfun(@(x) find(x), incorrectBeeImageRowLabels, UniformOutput=false);

h = figure;
violinplot(vertcat(rows{:}),categorical("misclassified bee rows"))
ylabel('range bin')

exportgraphics(h,testingResultsDir + filesep + "rows-of-missed-bees-cnn-2d-3layer.png")
