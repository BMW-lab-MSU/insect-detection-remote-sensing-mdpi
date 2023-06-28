function model = fitCnn1dSmall(data, labels, hyperparams)
arguments
    data (:,1) cell 
    labels (:,1) categorical 
    hyperparams (1,1) struct
end

% SPDX-License-Identifier: BSD-3-Clause


%%
classes = categories(labels);
numClasses = numel(classes);

%%
filterSize = 10;
numFilters = 20;

layers = [ ...
    sequenceInputLayer(1, MinLength=1024)
    convolution1dLayer(filterSize,numFilters)
    batchNormalizationLayer
    reluLayer
    dropoutLayer
    convolution1dLayer(filterSize,2*numFilters)
    batchNormalizationLayer
    reluLayer
    dropoutLayer(0.2)
    globalMaxPooling1dLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer(Classes=classes,ClassWeights=hyperparams.Cost)];

options = trainingOptions("adam", ...
    MaxEpochs=5, ...
    InitialLearnRate=0.01, ...
    SequenceLength=1024, ...
    Verbose=false, ...
    MiniBatchSize=2048, ...
    Shuffle="every-epoch", ...
    Plots="none");

%% Train

model = trainNetwork(data, labels, layers, options);
