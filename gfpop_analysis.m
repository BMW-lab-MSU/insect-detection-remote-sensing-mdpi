baseDir = "../data/raw";
dates = ["2022-06-23" "2022-06-24" "2022-07-28" "2022-07-29"];
folderPrefix = "MSU-horticulture-farm-bees-";
imageNum0623 = ["122126" "135615" "141253" "144154" "145241"];
imageNum0624 = ["094752" "095001" "104012" "105017" "110409" "111746" "113017" "114343"];
imageNum0728 = ["112652" "120850" "123948" "124905" "131133" "133834" "135906" "141427" "143013" "144821"];
imageNum0729 = ["090758" "093945" "095958" "101924"];
scanNumbers = {imageNum0623, imageNum0624, imageNum0728, imageNum0729};
rowResultsOriginal = "rowResultsOriginal.mat";
colResultsOriginal = "colResultsOriginal.mat";
rowResultsSparse = "rowResultsSparse.mat";
colResultsSparse = "colResultsSparse.mat";
labelsName = "labels.mat";

% Matrix Initialization
totalRowResultsOriginal = [0 0 ; 0 0];
totalColResultsOriginal = [0 0 ; 0 0];
totalRowResultsSparse = [0 0 ; 0 0];
totalColResultsSparse = [0 0 ; 0 0];

% Folder Setup
for index = 1:length(dates)
date = dates(index);
scanNums = scanNumbers{index};
for scanNum = 1:length(scanNums)
rowResultsOriginalDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + rowResultsOriginal;
colResultsOriginalDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + colResultsOriginal;
rowResultsSparseDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + rowResultsSparse;
colResultsSparseDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + colResultsSparse;
labelsDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + labelsName;

    % Loading Image Labels
    labelsIn = load(labelsDirectory);
    imagesTrue = labelsIn.imageLabels;

    % Loading Row Results
    rowResultsIn = load(rowResultsSparseDirectory);
    rowResultsTMP = rowResultsIn.results{1,1};
    rowResultsSparseImages = rowResultsTMP(:,2);
    rowResultsIn = load(rowResultsOriginalDirectory);
    rowResultsTMP = rowResultsIn.results{1,1};
    rowResultsOriginalImages = rowResultsTMP(:,2);

    % Loading Column Results
    colResultsIn = load(colResultsSparseDirectory);
    colResultsTMP = colResultsIn.results{1,1};
    colResultsSparseImages = colResultsTMP(:,2);
    colResultsIn = load(colResultsOriginalDirectory);
    colResultsTMP = colResultsIn.results{1,1};
    colResultsOriginalImages =colResultsTMP(:,2);

    % Creating Vectors for Confusion Matrix
    rowOriginalPredicted = logical(rowResultsOriginalImages);
    colOriginalPredicted = logical(colResultsOriginalImages);
    rowSparsePredicted = logical(rowResultsSparseImages);
    colSparsePredicted = logical(colResultsSparseImages);

    % Creating Confusion Matrix
    rowOriginalMatrix = confusionmat(imagesTrue,rowOriginalPredicted);
    colOriginalMatrix = confusionmat(imagesTrue,colOriginalPredicted);
    rowSparseMatrix = confusionmat(imagesTrue,rowSparsePredicted);
    colSparseMatrix = confusionmat(imagesTrue,colSparsePredicted);

    % Analyzing and Combining Matrices
   if(imagesTrue == rowOriginalPredicted)
        rowSparseMatrix = [(sum(imagesTrue(:)) == 0)*rowOriginalMatrix 0 ; 0 (sum(imagesTrue(:)) == 1)*rowOriginalMatrix];
    end

    if(imagesTrue == colOriginalPredicted)
        colSparseMatrix = [(sum(imagesTrue(:)) == 0)*colOriginalMatrix 0 ; 0 (sum(imagesTrue(:)) == 1)*colOriginalMatrix];
    end

    if(imagesTrue == rowSparsePredicted)
        rowSparseMatrix = [(sum(imagesTrue(:)) == 0)*rowSparseMatrix 0 ; 0 (sum(imagesTrue(:)) == 1)*rowSparseMatrix];
    end

    if(imagesTrue == colSparsePredicted)
        colSparseMatrix = [(sum(imagesTrue(:)) == 0)*colSparseMatrix 0 ; 0 (sum(imagesTrue(:)) == 1)*colSparseMatrix];
    end

    totalRowResultsOriginal = totalRowResultsOriginal + rowOriginalMatrix;
    totalColResultsOriginal = totalColResultsOriginal + colOriginalMatrix;
    totalRowResultsSparse = totalRowResultsSparse + rowSparseMatrix;
    totalColResultsSparse = totalColResultsSparse + colSparseMatrix;

end
end

figure(1);
fullRowMatrixOriginal = confusionchart(totalRowResultsOriginal,{'no bee' 'bee'}); title('Rows - Original');
save("totalRowResults.mat","fullRowMatrixOriginal");
figure(2);
fullColMatrixOriginal = confusionchart(totalColResultsOriginal,{'no bee' 'bee'}); title('Cols - Original');
save("totalColResults.mat","fullColMatrixOriginal");
figure(3);
fullRowMatrixSparse = confusionchart(totalRowResultsSparse,{'no bee' 'bee'}); title('Rows - Sparse');
save("totalRowResults.mat","fullRowMatrixSparse");
figure(4);
fullColMatrixSparse = confusionchart(totalColResultsSparse,{'no bee' 'bee'}); title('Cols - Sparse');
save("totalColResults.mat","fullColMatrixSparse");