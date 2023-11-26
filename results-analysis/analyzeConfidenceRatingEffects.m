beehiveDataSetup;

resultsDirs = ["../results/testing","../results2/testing","../results3/testing"];

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

    for i = 1:numel(resultsDirs)
        load(resultsDirs(i) + filesep + classifier + "Results.mat")

        predictions = results.Row.PredictedLabels;
        if iscategorical(predictions)
            predictions = predictions=='true';
        end

        wasPredictionCorrect = predictions == trueLabels;

        wasBeePredictionCorrect = wasPredictionCorrect(beeIdx);

        beeConfidenceRatings = confidenceRatings(beeIdx);

        for confidenceLevel = confidenceLevels'
            idx = find(beeConfidenceRatings == confidenceLevel);

            metrics(confidenceLevel).NumCorrect(i) = sum(wasBeePredictionCorrect(idx) == true);
            metrics(confidenceLevel).NumIncorrect(i) = sum(wasBeePredictionCorrect(idx) == false);
            metrics(confidenceLevel).PctCorrect(i) = metrics(confidenceLevel).NumCorrect(i) / numel(idx);
            metrics(confidenceLevel).NumBees(i) = numel(idx);

        end
    end

    confidenceMetrics(classifier).Confidence = metrics;
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
    end

    confidenceMetrics(changepointMethods(i)).Confidence = metrics;
end

save(testingResultsDir + filesep + "confidenceRatingEffects.mat","confidenceMetrics")

