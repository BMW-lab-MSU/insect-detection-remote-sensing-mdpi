%% Setup
if(isempty(gcp('nocreate')))
    parpool('IdleTimeout',inf);
end

% Global testing and Reconstruction Variables
numSparse = 4;
dSize = 2048;

%% Load dictionary
load(sparseCodingDataDir + filesep + "D" + dSize + ".mat");

%% Load testing data
load(testingDataDir + filesep + "testingData.mat", 'testingData', 'testingImgLabels');

%% Generate difference images

% preallocate cell array for difference images
testingDifferenceImages = cell(size(testingData));

parfor imageNum = 1:numel(testingData)
    testingDifferenceImages{imageNum} = generateDifferenceImages(testingData{imageNum},numSparse,D);
end

%% Compute reconstruction errors
reconstructionErrors = cellfun(@(x) norm(x,'fro'), testingDifferenceImages);

nonBeeReconstructionErrors = reconstructionErrors(testingImgLabels == 0);
beeReconstructionErrors = reconstructionErrors(testingImgLabels);

%% Save results
save(testingDataDir + filesep + "testingDifferenceImages.mat", 'testingDifferenceImages', '-v7.3');

if ~exist(sparseCodingResultsDir, 'dir')
    mkdir(baseResultsDir,"sparse-coding")
end
save(sparseCodingResultsDir + filesep + "testingReconstructionErrorsD" + string(dSize), ...
    'reconstructionErrors', 'nonBeeReconstructionErrors', 'beeReconstructionErrors', '-v7.3');
