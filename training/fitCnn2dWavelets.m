function model = fitCnn2dWavelets(data, hyperparams)
arguments
    data (1,1)  
    hyperparams (1,1) struct
end

% SPDX-License-Identifier: BSD-3-Clause

%%
classes = categories(data.Labels);
classWeights = 1./countcats(data.Labels);
classWeights = classWeights'/mean(classWeights);
numClasses = numel(classes);


dropoutProb = 0.2;
numF = 12;
layers = [
    imageInputLayer([71, 1024, 1], Normalization='none')
    
    convolution2dLayer(3,numF,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(3,Stride=2,Padding="same")
    
    convolution2dLayer(3,2*numF,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(3,Stride=2,Padding="same")
    
    convolution2dLayer(3,4*numF,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(3,Stride=2,Padding="same")
    
    convolution2dLayer(3,4*numF,Padding="same")
    batchNormalizationLayer
    reluLayer

    convolution2dLayer(3,4*numF,Padding="same")
    batchNormalizationLayer
    reluLayer
    globalMaxPooling2dLayer
    dropoutLayer(dropoutProb)

    fullyConnectedLayer(numClasses)
    softmaxLayer
    focalLossLayer];
    % classificationLayer(Classes=classes,ClassWeights=classWeights)];

miniBatchSize = 128;
options = trainingOptions("adam", ...
    InitialLearnRate=0.01, ...
    MaxEpochs=5, ...
    MiniBatchSize=miniBatchSize, ...
    Shuffle="every-epoch", ...
    Plots='training-progress', ...
    Verbose=false);

%%
model = trainNetwork(data, layers, options);
