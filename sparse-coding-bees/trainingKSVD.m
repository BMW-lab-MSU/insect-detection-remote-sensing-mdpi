rng(0,"twister");

% Global Training and Reconstruction Variables
numSparse = 4;
dSize = 2048;

% 10% Non-Bee Training
load(trainingDir + filesep + "ksvdTrainingData.mat");

% convert training data to a matrix instead of cell array
data = vertcat(ksvdTrainingData{:}).';

[D,err] = trainKSVD(data,numSparse,dSize,200,'high');

if ~exist(baseDir + "sparse-coding")
    mkdir(baseDir, "sparse-coding");
end

save(baseDir + filsep + "sparse-coding" + filsep + "D" + string(dSize) + ".mat",'D', '-v7.3');
save(baseDir + filsep + "sparse-coding" + filsep + "err" + string(dSize) + ".mat",'err', '-v7.3');
