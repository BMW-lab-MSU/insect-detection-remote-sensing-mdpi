%% Setup
if(isempty(gcp('nocreate')))
    parpool('IdleTimeout',inf);
end

% Global validation and Reconstruction Variables
numSparse = 4;
dSize = 2048;

%% Load dictionary
load(sparseCodingDataDir + filesep + "D" + dSize + ".mat");

%% Load validation data
load(validationDataDir + filesep + "validationData.mat", 'validationData', 'validationImgLabels');

%% Generate difference images

% preallocate cell array for difference images
validationDifferenceImages = cell(size(validationData));

parfor imageNum = 1:numel(validationData)
    validationDifferenceImages{imageNum} = generateDifferenceImages(validationData{imageNum},numSparse,D);
end

%% Compute reconstruction errors
reconstructionErrors = cellfun(@(x) norm(x,'fro'), validationDifferenceImages);

nonBeeReconstructionErrors = reconstructionErrors(validationImgLabels == 0);
beeReconstructionErrors = reconstructionErrors(validationImgLabels);

%% Save results
save(validationDataDir + filesep + "validationDifferenceImages.mat", 'validationDifferenceImages', '-v7.3');

if ~exist(sparseCodingResultsDir, 'dir')
    mkdir(baseResultsDir,"sparse-coding")
end
save(sparseCodingResultsDir + filesep + "validationReconstructionErrorsD" + string(dSize), ...
    'reconstructionErrors', 'nonBeeReconstructionErrors', 'beeReconstructionErrors', '-v7.3');
