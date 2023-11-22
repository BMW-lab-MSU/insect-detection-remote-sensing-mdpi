beehiveDataSetup;

classifiers = ["RUSBoost","AdaBoost","StatsNeuralNetwork1Layer",...
    "StatsNeuralNetwork3Layer","StatsNeuralNetwork5Layer",...
    "StatsNeuralNetwork7Layer","CNN1d1Layer","CNN1d3Layer","CNN1d5Layer",...
    "CNN1d7Layer"];

changepointMethods = ["gfpopRows","matlabRows","gfpopCols","matlabCols",...
    "gfpopBoth","matlabBoth"];
changepointResultsFilename = ["rowResultsOriginal_gfpop",...
    "rowResultsOriginal_matlab","colResultsOriginal_gfpop",...
    "colResultsOriginal_matlab","bothResultsOriginal_gfpop",...
    "bothResultsOriginal_matlab"];

methodNames = [classifiers, changepointMethods];

nMethods = numel(methodNames);

confidenceMetrics = dictionary(methodNames,repelem(struct(),1,nMethods));

load(testingDataDir + filesep + "testingData","testingRowLabels","testingRowConfidence")

trueLabels = vertcat(testingRowLabels{:});
confidenceRatings = vertcat(testingRowConfidence{:});

confidenceLevels = unique(confidenceRatings);
confidenceLevels(confidenceLevels == 0) = [];

beeIdx = find(trueLabels);

for classifier = classifiers
    disp(classifier)
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

        confidenceMetrics(classifier).Confidence = metrics;
    end
end

for i = 1:numel(changepointMethods)
    disp(changepointMethods(i))
    load(changepointResultsDir + filesep + changepointResultsFilename(i))

    predictions = logical(horzcat(results{2}{:})');

    wasPredictionCorrect = predictions == trueLabels;

    wasBeePredictionCorrect = wasPredictionCorrect(beeIdx);

    beeConfidenceRatings = confidenceRatings(beeIdx);

    for confidenceLevel = confidenceLevels'
        idx = find(beeConfidenceRatings == confidenceLevel);

        metrics(confidenceLevel).NumCorrect = sum(wasBeePredictionCorrect(idx) == true);
        metrics(confidenceLevel).NumIncorrect = sum(wasBeePredictionCorrect(idx) == false);
        metrics(confidenceLevel).PctCorrect = metrics(confidenceLevel).NumCorrect / numel(idx);
        metrics(confidenceLevel).NumBees = numel(idx);

        confidenceMetrics(changepointMethods(i)).Confidence = metrics;
    end
end

save(testingResultsDir + filesep + "confidenceRatingEffects.mat","confidenceMetrics")

pctCorrect = zeros(nMethods,numel(confidenceLevels));
for i = 1:nMethods
    pctCorrect(i,:) = [confidenceMetrics(methodNames(i)).Confidence.PctCorrect];
end

bar(categorical(methodNames),pctCorrect)
