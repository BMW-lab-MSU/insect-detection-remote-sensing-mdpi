clc; clear figures; clear;
rng(0,"twister");
if(isempty(gcp('nocreate')))
    parpool('IdleTimeout',inf);
end

% Loading Data and Toolbox Directories
addpath("/home/group/bradwhitaker/sparse-coding-toolboxes/ksvd");
addpath("/home/group/bradwhitaker/sparse-coding-toolboxes/omp");

% Global Training and Reconstruction Variables
numSparse = 4;
dSize = 2048;

% 10% Non-Bee Training
load("nonBee10PercentTraining.mat");
[D,err] = trainKSVD(double(nonBee10PercentTraining),numSparse,dSize,200,'high');
save("D" + string(dSize) + ".mat",D);
save("err" + string(dSize) + ".mat",err);
clear nonBee10Percent;