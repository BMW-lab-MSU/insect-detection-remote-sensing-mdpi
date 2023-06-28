%% Setup
if(isempty(gcp('nocreate')))
    parpool('IdleTimeout',inf);
end

% Global Training and Reconstruction Variables
numSparse = 4;
dSize = 2048;

%% Load dictionary
load(sparseCodingDataDir + filesep + "D" + dSize + ".mat");

%% Load training data
load(trainingDataDir + filesep + "trainingData.mat", 'trainingData', 'trainingImgLabels');

%% Generate difference images

% preallocate cell array for difference images
trainingDifferenceImages = cell(size(trainingData));

parfor imageNum = 1:numel(trainingData)
    trainingDifferenceImages{imageNum} = generateDifferenceImages(trainingData{imageNum},numSparse,D);
end

%% Compute reconstruction errors
reconstructionErrors = cellfun(@(x) norm(x,'fro'), trainingDifferenceImages);

nonBeeReconstructionErrors = reconstructionErrors(trainingImgLabels == 0);
beeReconstructionErrors = reconstructionErrors(trainingImgLabels);

%% Save results
save(trainingDataDir + filesep + "trainingDifferenceImages.mat", 'trainingDifferenceImages', '-v7.3');

if ~exist(sparseCodingResultsDir, 'dir')
    mkdir(baseResultsDir,"sparse-coding")
end
save(sparseCodingResultsDir + filesep + "trainingReconstructionErrorsD" + string(dSize), ...
    'reconstructionErrors', 'nonBeeReconstructionErrors', 'beeReconstructionErrors', '-v7.3');
