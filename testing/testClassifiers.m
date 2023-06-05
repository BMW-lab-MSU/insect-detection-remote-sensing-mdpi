% SPDX-License-Identifier: BSD-3-Clause
%% Setup

%% Load data
load([testingDir filesep 'testingData.mat']);

features = vertcat(testingFeatures{:});
labels = vertcat(testingLabels{:});

cnn2dTestingData = cat(4, testingData{:});
cnn2dTestingLabels = categorical(cellfun(@(c) any(c), testingLabels));

cnn1dTestingData = mat2cell(vertcat(testingData{:}), ones(178*numel(testingData),1),1024);
cnn1dTestingLabels = categorical(labels);


%% Test AdaBoost
disp('Testing AdaBoost....')
disp('---------------')
disp('')
load([trainingDir filesep 'models' filesep 'ADABoost.mat']);

%%%%%%%%%%%%%%%%%%
% row results
%%%%%%%%%%%%%%%%%%
adaBoost.Row.PredLabels = predict(model, features);

adaBoost.Row.Confusion = confusionmat(labels, adaBoost.Row.PredLabels);

[a, p, r, f2, mcc] = analyzeConfusion(adaBoost.Row.Confusion);
adaBoost.Row.Accuracy = a;
adaBoost.Row.Precision = p;
adaBoost.Row.Recall = r;
adaBoost.Row.F2 = f2;
adaBoost.Row.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
[imageConf, imageTrue, imagePred]  = imageConfusion(adaBoost.Row.PredLabels, testingLabels, holdoutPartition);
adaBoost.Image.Confusion = imageConf;
adaBoost.Image.PredLabels = imagePred;
adaBoost.Image.TrueLabels = imageTrue;

[a, p, r, f2, mcc] = analyzeConfusion(adaBoost.Image.Confusion);
adaBoost.Image.Accuracy = a;
adaBoost.Image.Precision = p;
adaBoost.Image.Recall = r;
adaBoost.Image.F2 = f2;
adaBoost.Image.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%%
disp('Row results')
disp(adaBoost.Row.Confusion)
disp(adaBoost.Row)
disp('Image results')
disp(adaBoost.Image.Confusion)
disp(adaBoost.Image)

%% Test RUSBoost
disp('Testing RUSBoost....')
disp('---------------')
disp('')
load([trainingDir filesep 'models' filesep 'RUSBoost.mat']);

%%%%%%%%%%%%%%%%%%
% row results
%%%%%%%%%%%%%%%%%%
rusBoost.Row.PredLabels = predict(model, features);

rusBoost.Row.Confusion = confusionmat(labels, rusBoost.Row.PredLabels);

[a, p, r, f2, mcc] = analyzeConfusion(rusBoost.Row.Confusion);
rusBoost.Row.Accuracy = a;
rusBoost.Row.Precision = p;
rusBoost.Row.Recall = r;
rusBoost.Row.F2 = f2;
rusBoost.Row.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
[imageConf, imageTrue, imagePred]  = imageConfusion(rusBoost.Row.PredLabels, testingLabels, holdoutPartition);
rusBoost.Image.Confusion = imageConf;
rusBoost.Image.PredLabels = imagePred;
rusBoost.Image.TrueLabels = imageTrue;

[a, p, r, f2, mcc] = analyzeConfusion(rusBoost.Image.Confusion);
rusBoost.Image.Accuracy = a;
rusBoost.Image.Precision = p;
rusBoost.Image.Recall = r;
rusBoost.Image.F2 = f2;
rusBoost.Image.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%%
disp('Row results')
disp(rusBoost.Row.Confusion)
disp(rusBoost.Row)
disp('Image results')
disp(rusBoost.Image.Confusion)
disp(rusBoost.Image)

%% Test neural net
disp('Testing neural net....')
disp('---------------')
disp('')
load([trainingDir filesep 'models' filesep 'NNet.mat']);

%%%%%%%%%%%%%%%%%%
% row results
%%%%%%%%%%%%%%%%%%
nnet.Row.PredLabels = predict(model, features);

nnet.Row.Confusion = confusionmat(labels, nnet.Row.PredLabels);

[a, p, r, f2, mcc] = analyzeConfusion(nnet.Row.Confusion);
nnet.Row.Accuracy = a;
nnet.Row.Precision = p;
nnet.Row.Recall = r;
nnet.Row.F2 = f2;
nnet.Row.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
[imageConf, imageTrue, imagePred]  = imageConfusion(nnet.Row.PredLabels, testingLabels, holdoutPartition);
nnet.Image.Confusion = imageConf;
nnet.Image.PredLabels = imagePred;
nnet.Image.TrueLabels = imageTrue;

[a, p, r, f2, mcc] = analyzeConfusion(nnet.Image.Confusion);
nnet.Image.Accuracy = a;
nnet.Image.Precision = p;
nnet.Image.Recall = r;
nnet.Image.F2 = f2;
nnet.Image.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%%
disp('Row results')
disp(nnet.Row.Confusion)
disp(nnet.Row)
disp('Image results')
disp(nnet.Image.Confusion)
disp(nnet.Image)


%% Test 2D CNN small
disp('Testing 2D CNN small....')
disp('---------------')
disp('')
load([trainingDir filesep 'models' filesep 'Cnn2dSmall.mat']);

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
cnn2dSmall.Image.PredLabels = classify(model, cnn2dTestingData);

cnn2dSmall.Image.Confusion = confusionmat(cnn2dTestingLabels, cnn2dSmall.Image.PredLabels);
cnn2dSmall.Image.TrueLabels = cnn2dTestingLabels;

[a, p, r, f2, mcc] = analyzeConfusion(cnn2dSmall.Image.Confusion);
cnn2dSmall.Image.Accuracy = a;
cnn2dSmall.Image.Precision = p;
cnn2dSmall.Image.Recall = r;
cnn2dSmall.Image.F2 = f2;
cnn2dSmall.Image.MCC = mcc;

disp('Image results')
disp(cnn2dSmall.Image.Confusion)
disp(cnn2dSmall.Image)



%% Test 2D CNN medium
disp('Testing 2D CNN medium....')
disp('---------------')
disp('')
load([trainingDir filesep 'models' filesep 'Cnn2dMedium.mat']);

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
cnn2dMedium.Image.PredLabels = classify(model, cnn2dTestingData);

cnn2dMedium.Image.Confusion = confusionmat(cnn2dTestingLabels, cnn2dMedium.Image.PredLabels);
cnn2dMedium.Image.TrueLabels = cnn2dTestingLabels;

[a, p, r, f2, mcc] = analyzeConfusion(cnn2dMedium.Image.Confusion);
cnn2dMedium.Image.Accuracy = a;
cnn2dMedium.Image.Precision = p;
cnn2dMedium.Image.Recall = r;
cnn2dMedium.Image.F2 = f2;
cnn2dMedium.Image.MCC = mcc;

disp('Image results')
disp(cnn2dMedium.Image.Confusion)
disp(cnn2dMedium.Image)


%% Test 2D CNN large
disp('Testing 2D CNN large....')
disp('---------------')
disp('')
load([trainingDir filesep 'models' filesep 'Cnn2dLarge.mat']);

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
cnn2dLarge.Image.PredLabels = classify(model, cnn2dTestingData);

cnn2dLarge.Image.Confusion = confusionmat(cnn2dTestingLabels, cnn2dLarge.Image.PredLabels);
cnn2dLarge.Image.TrueLabels = cnn2dTestingLabels;

[a, p, r, f2, mcc] = analyzeConfusion(cnn2dLarge.Image.Confusion);
cnn2dLarge.Image.Accuracy = a;
cnn2dLarge.Image.Precision = p;
cnn2dLarge.Image.Recall = r;
cnn2dLarge.Image.F2 = f2;
cnn2dLarge.Image.MCC = mcc;

disp('Image results')
disp(cnn2dLarge.Image.Confusion)
disp(cnn2dLarge.Image)



%% Test cnn 1d small
disp('Testing cnn 1d small....')
disp('---------------')
disp('')
load([trainingDir filesep 'models' filesep 'Cnn1dSmall.mat']);

%%%%%%%%%%%%%%%%%%
% row results
%%%%%%%%%%%%%%%%%%
cnn1dSmall.Row.PredLabels = classify(model, cnn1dTestingData);

cnn1dSmall.Row.Confusion = confusionmat(cnn1dTestingLabels, cnn1dSmall.Row.PredLabels);

[a, p, r, f2, mcc] = analyzeConfusion(cnn1dSmall.Row.Confusion);
cnn1dSmall.Row.Accuracy = a;
cnn1dSmall.Row.Precision = p;
cnn1dSmall.Row.Recall = r;
cnn1dSmall.Row.F2 = f2;
cnn1dSmall.Row.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
[imageConf, imageTrue, imagePred]  = imageConfusion(cnn1dSmall.Row.PredLabels == 'true', testingLabels, holdoutPartition);
cnn1dSmall.Image.Confusion = imageConf;
cnn1dSmall.Image.PredLabels = imagePred;
cnn1dSmall.Image.TrueLabels = imageTrue;

[a, p, r, f2, mcc] = analyzeConfusion(cnn1dSmall.Image.Confusion);
cnn1dSmall.Image.Accuracy = a;
cnn1dSmall.Image.Precision = p;
cnn1dSmall.Image.Recall = r;
cnn1dSmall.Image.F2 = f2;
cnn1dSmall.Image.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%%
disp('Row results')
disp(cnn1dSmall.Row.Confusion)
disp(cnn1dSmall.Row)
disp('Image results')
disp(cnn1dSmall.Image.Confusion)
disp(cnn1dSmall.Image)



%% Test cnn 1d medium
disp('Testing cnn 1d medium....')
disp('---------------')
disp('')
load([trainingDir filesep 'models' filesep 'Cnn1dMedium.mat']);

%%%%%%%%%%%%%%%%%%
% row results
%%%%%%%%%%%%%%%%%%
cnn1dMedium.Row.PredLabels = classify(model, cnn1dTestingData);

cnn1dMedium.Row.Confusion = confusionmat(cnn1dTestingLabels, cnn1dMedium.Row.PredLabels);

[a, p, r, f2, mcc] = analyzeConfusion(cnn1dMedium.Row.Confusion);
cnn1dMedium.Row.Accuracy = a;
cnn1dMedium.Row.Precision = p;
cnn1dMedium.Row.Recall = r;
cnn1dMedium.Row.F2 = f2;
cnn1dMedium.Row.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
[imageConf, imageTrue, imagePred]  = imageConfusion(cnn1dMedium.Row.PredLabels == 'true', testingLabels, holdoutPartition);
cnn1dMedium.Image.Confusion = imageConf;
cnn1dMedium.Image.PredLabels = imagePred;
cnn1dMedium.Image.TrueLabels = imageTrue;

[a, p, r, f2, mcc] = analyzeConfusion(cnn1dMedium.Image.Confusion);
cnn1dMedium.Image.Accuracy = a;
cnn1dMedium.Image.Precision = p;
cnn1dMedium.Image.Recall = r;
cnn1dMedium.Image.F2 = f2;
cnn1dMedium.Image.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%%
disp('Row results')
disp(cnn1dMedium.Row.Confusion)
disp(cnn1dMedium.Row)
disp('Image results')
disp(cnn1dMedium.Image.Confusion)
disp(cnn1dMedium.Image)


%% Test lstm
disp('Testing lstm....')
disp('---------------')
disp('')
load([trainingDir filesep 'models' filesep 'lstm.mat']);

%%%%%%%%%%%%%%%%%%
% row results
%%%%%%%%%%%%%%%%%%
lstm.Row.PredLabels = classify(model, cnn1dTestingData);

lstm.Row.Confusion = confusionmat(cnn1dTestingLabels, lstm.Row.PredLabels);

[a, p, r, f2, mcc] = analyzeConfusion(lstm.Row.Confusion);
lstm.Row.Accuracy = a;
lstm.Row.Precision = p;
lstm.Row.Recall = r;
lstm.Row.F2 = f2;
lstm.Row.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
[imageConf, imageTrue, imagePred]  = imageConfusion(lstm.Row.PredLabels == 'true', testingLabels, holdoutPartition);
lstm.Image.Confusion = imageConf;
lstm.Image.PredLabels = imagePred;
lstm.Image.TrueLabels = imageTrue;

[a, p, r, f2, mcc] = analyzeConfusion(lstm.Image.Confusion);
lstm.Image.Accuracy = a;
lstm.Image.Precision = p;
lstm.Image.Recall = r;
lstm.Image.F2 = f2;
lstm.Image.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%%
disp('Row results')
disp(lstm.Row.Confusion)
disp(lstm.Row)
disp('Image results')
disp(lstm.Image.Confusion)
disp(lstm.Image)


%% Save results
save([testingDir filesep 'results'], 'adaBoost', 'rusBoost', 'nnet','lstm','cnn1dSmall','cnn1dMedium','cnn2dSmall','cnn2dMedium','cnn2dLarge');
