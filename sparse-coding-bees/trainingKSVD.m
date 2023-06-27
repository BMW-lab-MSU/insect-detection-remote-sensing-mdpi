rng(0,"twister");

% Global Training and Reconstruction Variables
numSparse = 4;
dSize = 2048;
nIter = 25;
memUsage = 'high';

% 10% Non-bee training data
load(trainingDir + filesep + "ksvdTrainingData.mat");

% convert training data to a matrix instead of cell array;
% the resulting matrix needs dimensions of 1024 x (# of observations),
% which is transposed compared to how our data is originally stored.
data = vertcat(ksvdTrainingData{:}).';

[D,err] = trainKSVD(data,numSparse,dSize,nIter,memUsage);

if ~exist(baseDir + filesep + "sparse-coding")
    mkdir(baseDir, "sparse-coding");
end

save(baseDir + filesep + "sparse-coding" + filesep + "D" + string(dSize) + ".mat",'D', '-v7.3');
save(baseDir + filesep + "sparse-coding" + filesep + "err" + string(dSize) + ".mat",'err', '-v7.3');
