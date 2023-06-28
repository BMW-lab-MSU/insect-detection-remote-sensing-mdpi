function model = fitLstm(data, labels, hyperparams)
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
layers = [ ...
    sequenceInputLayer(1)
    bilstmLayer(100, OutputMode="last")
    dropoutLayer(0.2)
%     bilstmLayer(20, OutputMode="last")
%     dropoutLayer(0.2)
    fullyConnectedLayer(2)
    softmaxLayer
%     focalLossLayer
    classificationLayer(Classes=classes,ClassWeights=hyperparams.Cost)];


options = trainingOptions("adam", ...
    ExecutionEnvironment="auto", ...
    GradientThreshold=1, ...
    MaxEpochs=5, ...
    MiniBatchSize=512, ...
    SequenceLength=1024, ...
    Verbose=0, ...
    Shuffle="every-epoch",...
    Plots="none");

%% Train

model = trainNetwork(data, labels, layers, options);
