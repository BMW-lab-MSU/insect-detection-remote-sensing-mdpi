beehiveDataSetup;

classifiers = ["RUSBoost","AdaBoost","StatsNeuralNetwork1Layer",...
    "StatsNeuralNetwork3Layer","StatsNeuralNetwork5Layer",...
    "StatsNeuralNetwork7Layer","CNN1d1Layer","CNN1d3Layer","CNN1d5Layer",...
    "CNN1d7Layer"];

nClassifiers = numel(classifiers);

confidenceMetrics = dictionary(classifiers,repelem(struct(),1,nClassifiers));

load(testingDataDir + filesep + "testingData","testingRowLabels","testingRowConfidence")

trueLabels = vertcat(testingRowLabels{:});
confidenceRatings = vertcat(testingRowConfidence{:});

confidenceLevels = unique(confidenceRatings);
confidenceLevels(confidenceLevels == 0) = [];

beeIdx = find(trueLabels);

for classifier = classifiers
    load(testingResultsDir + filesep + classifier + "Results.mat")

    predictions = results.Row.PredictedLabels;
    if iscategorical(predictions)
        predictions = predictions=='true';
    end

    wasPredictionCorrect = predictions == trueLabels;

    wasBeePredictionCorrect = wasPredictionCorrect(beeIdx);

    beeConfidenceRatings = confidenceRatings(beeIdx);

    for confidenceLevel = confidenceLevels'
        idx = find(beeConfidenceRatings == confidenceLevel);

        metrics(confidenceLevel).NumCorrect = sum(wasBeePredictionCorrect(idx) == true);
        metrics(confidenceLevel).NumIncorrect = sum(wasBeePredictionCorrect(idx) == false);
        metrics(confidenceLevel).PctCorrect = metrics(confidenceLevel).NumCorrect / numel(idx);
        metrics(confidenceLevel).NumBees = numel(idx);

        confidenceMetrics(classifier).Metrics = metrics;
    end
end

save(testingResultsDir + filesep + "confidenceRatingEffects.mat","confidenceMetrics")

pctCorrect = zeros(numel(classifiers),numel(confidenceLevels));
for i = 1:numel(classifiers)
    pctCorrect(i,:) = [confidenceMetrics(classifiers(i)).Metrics.PctCorrect];
end

bar(categorical(classifiers),pctCorrect)
