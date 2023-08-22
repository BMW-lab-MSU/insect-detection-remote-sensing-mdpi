%% Load in data
beehiveDataSetup;

load(testingDataDir + filesep + "testingData");

%% Load in results
load(testingResultsDir + filesep + "StatsNeuralNetwork3LayerResults");

%% Convert row results back into cell arrays for each image
N_ROWS = 178;
nImages = numel(testingData);

predictedLabels = mat2cell(results.Row.PredictedLabels, N_ROWS * ones(1,nImages),1);
trueLabels = mat2cell(results.Row.TrueLabels, N_ROWS * ones(1,nImages),1);

%% Find true positive images
tpImageIdx = find((results.Image.PredictedLabels == 1) & (results.Image.TrueLabels == 1));

%% Find any true positive images that did not get all the row predictions correct
imgCorrectRowIncorrectIdx = [];
extraPredictedLabels = [];
extraTrueLabels = [];
sameAmountLabels = [];

for imgIdx = tpImageIdx'
    if any(predictedLabels{imgIdx} ~= trueLabels{imgIdx})
        imgCorrectRowIncorrectIdx = [imgCorrectRowIncorrectIdx, imgIdx];

        nPredicted = nnz(predictedLabels{imgIdx});
        nTrue = nnz(trueLabels{imgIdx});
   
        if nPredicted > nTrue
            extraPredictedLabels = [extraPredictedLabels, imgIdx];
        elseif nTrue > nPredicted
            extraTrueLabels = [extraTrueLabels, imgIdx];
        else
            sameAmountLabels = [sameAmountLabels, imgIdx];
        end
    end

 
end
    