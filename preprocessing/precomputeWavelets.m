%% Setup
datadir = '../data';
trainingDir = [datadir filesep 'training'];
testingDir = [datadir filesep 'testing'];
trainingWaveletDir = [trainingDir filesep 'wavelets'];
testingWaveletDir = [testingDir filesep 'wavelets'];

if ~exist(trainingWaveletDir)
    mkdir(trainingWaveletDir)
end
if ~exist(testingWaveletDir)
    mkdir(testingWaveletDir)
end

N_ROWS = 178;
N_COLS = 1024;
N_WAVELET_ROWS = 71;

if isempty(gcp('nocreate'))
    parpool('IdleTimeout', Inf);
end

%% Load in training and testing data
load([trainingDir filesep 'trainingData'], 'trainingData')
load([testingDir filesep 'testingData'], 'testingData')

%% Setup wavelet transform
waveletFilterbank = cwtfilterbank;

%% Compute training wavelets
parfor imageNum = (1:numel(trainingData))

    waveletMag = zeros(N_WAVELET_ROWS, N_COLS, N_ROWS, 'uint16');
    waveletPhase = zeros(N_WAVELET_ROWS, N_COLS, N_ROWS, 'uint16');

    for rowNum = 1:N_ROWS
        wavelet = wt(waveletFilterbank,trainingData{imageNum}(rowNum,:));
        
        % scale magnitude and phase to be full-scale uint16s 
        waveletMag(:,:,rowNum) = uint16(rescale(abs(wavelet), 0, 2^16 - 1));
        waveletPhase(:,:,rowNum) = uint16(rescale(angle(wavelet), 0, 2^16 - 1));
    end

    % batch save wavelets to hopefully make this code slightly less I/O-bound...
    for rowNum = 1:N_ROWS
        waveletMagFilename = ...
            sprintf('trainingWaveletMagnitudeImage%04dRow%03d.tiff', ...
            imageNum, rowNum);
        imwrite(waveletMag(:,:,rowNum), ...
            [trainingWaveletDir filesep waveletMagFilename], 'tiff');

        waveletPhaseFilename = ...
            sprintf('trainingWaveletPhaseImage%04dRow%03d.tiff', ...
            imageNum, rowNum);
        imwrite(waveletPhase(:,:,rowNum), ...
            [trainingWaveletDir filesep waveletPhaseFilename], 'tiff');
    end
end

%% Compute testing wavelets
parfor imageNum = (1:numel(testingData))

    waveletMag = zeros(N_WAVELET_ROWS, N_COLS, N_ROWS, 'uint16');
    waveletPhase = zeros(N_WAVELET_ROWS, N_COLS, N_ROWS, 'uint16');

    for rowNum = 1:N_ROWS
        wavelet = wt(waveletFilterbank,testingData{imageNum}(rowNum,:));
        
        % scale magnitude and phase to be full-scale uint16s 
        waveletMag(:,:,rowNum) = uint16(rescale(abs(wavelet), 0, 2^16 - 1));
        waveletPhase(:,:,rowNum) = uint16(rescale(angle(wavelet), 0, 2^16 - 1));
    end

    % batch save wavelets to hopefully make this code slightly less I/O-bound...
    for rowNum = 1:N_ROWS
        waveletMagFilename = ...
            sprintf('testingWaveletMagnitudeImage%04dRow%03d.tiff', ...
            imageNum, rowNum);
        imwrite(waveletMag(:,:,rowNum), ...
            [testingWaveletDir filesep waveletMagFilename], 'tiff');

        waveletPhaseFilename = ...
            sprintf('testingWaveletPhaseImage%04dRow%03d.tiff', ...
            imageNum, rowNum);
        imwrite(waveletPhase(:,:,rowNum), ...
            [testingWaveletDir filesep waveletPhaseFilename], 'tiff');
    end
end