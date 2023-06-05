function model = fitCnn2dSmall(data, labels, hyperparams)
arguments
    data (:,1) cell 
    labels (:,1) cell 
    hyperparams (1,1) struct
end

% SPDX-License-Identifier: BSD-3-Clause

%% Format data
% Image CNNs expect the data input to be 4-D array of 2D images:
% width x height x (num channels) x (num images)
trainingData = cat(4, data{:});

% This CNN only classifies entire images, so we need to create image labels;
% plus, trainNetwork expects categorical labels instead of logical/etc.
trainingImageLabels = categorical(cellfun(@(c) any(c), labels, 'UniformOutput',true));

%%
classes = categories(trainingImageLabels);
numClasses = numel(classes);


dropoutProb = 0.2;
numF = 24;
layers = [
    imageInputLayer([size(trainingData(:,:,1,1)), 1])
    
    convolution2dLayer(3,numF,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(3,Stride=2,Padding="same")
    
    convolution2dLayer(3,2*numF,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(3,Stride=2,Padding="same")
    
    globalMaxPooling2dLayer
    dropoutLayer(dropoutProb)

    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer(Classes=classes,ClassWeights=hyperparams.Cost)];

miniBatchSize = 64;
options = trainingOptions("adam", ...
    InitialLearnRate=0.001, ...
    MaxEpochs=30, ...
    MiniBatchSize=miniBatchSize, ...
    Shuffle="every-epoch", ...
    Verbose=false);

%%
model = trainNetwork(trainingData, trainingImageLabels, layers, options);
