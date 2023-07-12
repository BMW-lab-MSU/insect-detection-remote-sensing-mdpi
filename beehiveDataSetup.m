%% Data directories
baseDataDir = "../data";
rawDataDir = baseDataDir + filesep + "raw";
combinedDataDir = baseDataDir + filesep + "combined";
preprocessedDataDir = baseDataDir + filesep + "preprocessed";
trainingDataDir = baseDataDir + filesep + "training";
testingDataDir = baseDataDir + filesep + "testing";
validationDataDir = baseDataDir + filesep + "validation";

% TODO: constants for filenames?, e.g. TRAINING_DATA = "trainingData.mat"

%% Results directories
baseResultsDir = "../results";
trainingResultsDir = baseResultsDir + filesep + "training";
samplingResultsDir = trainingResultsDir + filesep + "data-sampling";
hyperparameterResultsDir = trainingResultsDir + filesep + "hyperparameter-tuning";

% TODO: precreate directories?
