function prepareFeaturesAndLabelsForPython
% prepareFeaturesAndLabelsForPython saves the training features and labels in
% a format that can easily be loaded in Python.
%
% We use Python to compute the mutual information between the training features
% and labels, in order to create a feature ranking. Python can't easily work
% with v7.3 mat files, or tables, so this function changes the features
% into an array, and saves everything in an older mat file version that can
% be loaded with scipy.io.loadmat().

% SPDX-License-Identifier: BSD-3-Clause

beehiveDataSetup

load(trainingDataDir + filesep + "trainingFeatures","trainingFeatures");
load(trainingDataDir + filesep + "trainingData","trainingRowLabels");

features = table2array(vertcat(trainingFeatures{:}));
labels = vertcat(trainingRowLabels{:});

save(trainingDataDir + filesep + "featuresAndLabelsForPythonMutualInfo.mat","features","labels");

end