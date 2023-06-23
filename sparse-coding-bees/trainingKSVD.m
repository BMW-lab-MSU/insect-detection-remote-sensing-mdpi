rng(0,"twister");

if(isempty(gcp('nocreate')))
    parpool('IdleTimeout',inf);
end

% Global Training and Reconstruction Variables
numSparse = 4;
dSize = 2048;

% 10% Non-Bee Training
load(trainingDir + "ksvdTrainingData.mat");

% convert training data to a matrix instead of cell array
data = cell2mat(ksvdTrainingData);

[D,err] = trainKSVD(data,numSparse,dSize,200,'high');

if ~exist(baseDir + "sparse-coding")
    mkdir(baseDir, "sparse-coding");
end

save(baseDir + "sparse-coding" + "D" + string(dSize) + ".mat",'D', '-v7.3');
save(baseDir + "sparse-coding" + "err" + string(dSize) + ".mat",'err', '-v7.3');