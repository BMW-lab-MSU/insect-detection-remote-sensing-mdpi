clc; clear figures; clear;
rng(0,"twister");
if(isempty(gcp('nocreate')))
    parpool('IdleTimeout',inf);
end

% Loading Data and Toolbox Directories
addpath("/home/group/bradwhitaker/sparse-coding-toolboxes/ksvd");
addpath("/home/group/bradwhitaker/sparse-coding-toolboxes/omp");

% Global Testing and Reconstruction Variables
numSparse = 4;
dSize = 2048;
load("D" + dSize + ".mat");

% 90% Non-Bee Reconstruction
load("nonBee90PercentTesting.mat");
nonBeeReconstructions = generateDifferenceImages(double(nonBee90PercentTesting),numSparse,D);
nonBeeError = norm(nonBeeReconstructions,'fro');
save("nonBeeReconstructions_" + string(dSize) + ".mat","nonBeeReconstructions");
save("nonBeeError_" + string(dSize) + ".mat","nonBeeError");
clear nonBee90Percent;

% Bee Reconstruction
load("beeImagesTesting.mat");
beeReconstructions = generateDifferenceImages(double(beeImagesTesting),numSparse,D);
beeErr = norm(beeReconstructions,'fro');
save("beeReconstructions_" + string(dSize) + ".mat","beeReconstructions");
save("beeError_" + string(dSize) + ".mat","beeErr");