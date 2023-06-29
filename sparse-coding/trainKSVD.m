function [Dtrain, err] = trainKSVD(data, numSparse, numAtoms, numIter,memUsage)
% This will take in the data to be used for training and run the ksvd
% algorithm on it. We need to specify the dictionary since the ksvd
% function can only make a 1000xX dictionary on its own. 


    %numAtoms specifies how many atoms the dictionary is going to use
    D = odct2dict([sqrt(size(data,1)) sqrt(size(data,1))], [numAtoms 1]); %Dictionary of size X x User Defined
   
    params.data = data; %OMP and KSVD require double type
    params.Tdata = numSparse; %Number of sparse coefficients
    params.iternum = numIter; %Number of iterations to run KSVD for
    params.initdict = D; %Initial dictionary
    params.memusage = memUsage; %Can specify how much memory can be used
    
    [Dtrain, ~, err] = ksvd(params,'tr'); %run KSVD
    
end