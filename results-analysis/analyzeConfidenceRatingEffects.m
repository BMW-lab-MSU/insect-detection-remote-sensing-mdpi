% SPDX-License-Identifier: BSD-3-Clause
beehiveDataSetup;

resultsDirs = ["../results/testing","../results2/testing","../results3/testing"];

classifiers = ["RUSBoost","AdaBoost","LinearSVM","StatsNeuralNetwork1Layer",...
    "StatsNeuralNetwork3Layer","StatsNeuralNetwork5Layer",...
    "StatsNeuralNetwork7Layer","CNN1d1Layer","CNN1d3Layer","CNN1d5Layer",...
    "CNN1d7Layer"];

changepointMethods = ["gfpopRows","matlabChptsRows","gfpopCols","matlabChptsCols",...
    "gfpopBoth","matlabChptsBoth"];

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
    load(changepointResultsDir + filesep + changepointMethods(i) + "Results.mat")

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

