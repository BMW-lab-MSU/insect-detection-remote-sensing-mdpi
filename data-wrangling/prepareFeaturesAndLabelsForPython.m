function prepareFeaturesAndLabelsForPython

beehiveDataSetup

load(trainingDataDir + filesep + "trainingFeatures","trainingFeatures");
load(trainingDataDir + filesep + "trainingData","trainingRowLabels");

features = table2array(vertcat(trainingFeatures{:}));
labels = vertcat(trainingRowLabels{:});

save(trainingDataDir + filesep + "featuresAndLabelsForPythonMutualInfo.mat","features","labels");

end