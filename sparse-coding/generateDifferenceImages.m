function [newData] = generateDifferenceImages(data, numSparse, dict)
% Generates the reconstruction error (difference) images. These will be used to retrain
% the models previously used. This is the sparse coding
% stage of ksvd, since the dictionary is known (and trained), and not being updated.

    % signals need to be in columns instead of rows, so we have to transpose the data
    dataT = data.';

    % project data onto the dictionary elements; this lets us run the fastest implementation
    % of omp, according to the omp help documentation.
    projections = dict.' * dataT;
    
    % compute the gram matrix
    G = dict' * dict; 

    % generate the sparse representations using OMP
    Gamma = omp(projections, G, numSparse); 
    
    % reconstruct the data using the sparse representations
    dataTilde = dict * Gamma; 

    % compute the reconstruction error: original data - reconstructed data
    % transpose the "difference image" so it matches the original data format
    newData = (dataT - dataTilde).'; 
end
