baseDir = "../data/raw";
dates = ["2022-06-23" "2022-06-24" "2022-07-28" "2022-07-29"];
folderPrefix = "MSU-horticulture-farm-bees-";
imageNum0623 = ["122126" "135615" "141253" "144154" "145241"];
imageNum0624 = ["094752" "095001" "104012" "105017" "110409" "111746" "113017" "114343"];
imageNum0728 = ["112652" "120850" "123948" "124905" "131133" "133834" "135906" "141427" "143013" "144821"];
imageNum0729 = ["093945" "095958" "101924"];
scanNumbers = {imageNum0623, imageNum0624, imageNum0728, imageNum0729};
rowResultsOriginalMatlab = "rowResultsOriginal_matlab.mat";
colResultsOriginalMatlab = "colResultsOriginal_matlab.mat";
rowResultsOriginalgfpop = "rowResultsOriginal_gfpop.mat";
colResultsOriginalgfpop = "colResultsOriginal_gfpop.mat";
bothResultsOriginalMatlab = "bothResultsOriginal_matlab.mat";
bothResultsOriginalgfpop = "bothResultsOriginal_gfpop.mat";
rowResultsSparseMatlab = "rowResultsOriginal_matlab.mat";
colResultsSparseMatlab = "colResultsOriginal_matlab.mat";
rowResultsSparsegfpop = "rowResultsSparse_gfpop.mat";
colResultsSparsegfpop = "colResultsSparse_gfpop.mat";
bothResultsSparseMatlab = "bothResultsSparse_matlab.mat";
bothResultsSparsegfpop = "bothResultsSparse_gfpop.mat";
labelsName = "labels.mat";

% Matrix Initialization
totalRowResultsOriginalMatlab = [0 0 ; 0 0];
totalColResultsOriginalMatlab = [0 0 ; 0 0];
totalBothResultsOriginalMatlab = [0 0 ; 0 0];
totalRowResultsSparseMatlab = [0 0 ; 0 0];
totalColResultsSparseMatlab = [0 0 ; 0 0];
totalBothResultsSparseMatlab = [0 0 ; 0 0];
totalRowResultsOriginalgfpop = [0 0 ; 0 0];
totalColResultsOriginalgfpop = [0 0 ; 0 0];
totalBothResultsOriginalgfpop = [0 0 ; 0 0];
totalRowResultsSparsegfpop = [0 0 ; 0 0];
totalColResultsSparsegfpop = [0 0 ; 0 0];
totalBothResultsSparsegfpop = [0 0 ; 0 0];

% Folder Setup
for index = 1:length(dates)
date = dates(index);
scanNums = scanNumbers{index};
for scanNum = 1:length(scanNums)
rowResultsOriginalDirectoryMatlab = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + rowResultsOriginalMatlab;
colResultsOriginalDirectoryMatlab = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + colResultsOriginalMatlab;
bothResultsOriginalDirectoryMatlab = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + bothResultsOriginalMatlab;
rowResultsSparseDirectoryMatlab = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + rowResultsSparseMatlab;
colResultsSparseDirectoryMatlab = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + colResultsSparseMatlab;
bothResultsSparseDirectoryMatlab = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + bothResultsSparseMatlab;
rowResultsOriginalDirectorygfpop = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + rowResultsOriginalgfpop;
colResultsOriginalDirectorygfpop = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + colResultsOriginalgfpop;
bothResultsOriginalDirectorygfpop = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + bothResultsOriginalgfpop;
rowResultsSparseDirectorygfpop = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + rowResultsSparsegfpop;
colResultsSparseDirectorygfpop = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + colResultsSparsegfpop;
bothResultsSparseDirectorygfpop = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + bothResultsSparsegfpop;
labelsDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + labelsName;

    % Loading Image Labels
    labelsIn = load(labelsDirectory);
    imagesTrue = labelsIn.imageLabels;

    % Loading Row Results
    rowResultsIn = load(rowResultsSparseDirectoryMatlab);
    rowResultsTMP = rowResultsIn.results{1,1};
    rowResultsSparseMatlabImages = rowResultsTMP(:,2);
    rowResultsIn = load(rowResultsOriginalDirectoryMatlab);
    rowResultsTMP = rowResultsIn.results{1,1};
    rowResultsOriginalMatlabImages = rowResultsTMP(:,2);
    rowResultsIn = load(rowResultsSparseDirectorygfpop);
    rowResultsTMP = rowResultsIn.results{1,1};
    rowResultsSparsegfpopImages = rowResultsTMP(:,2);
    rowResultsIn = load(rowResultsOriginalDirectorygfpop);
    rowResultsTMP = rowResultsIn.results{1,1};
    rowResultsOriginalgfpopImages = rowResultsTMP(:,2);
    

    % Loading Column Results
    colResultsIn = load(colResultsSparseDirectoryMatlab);
    colResultsTMP = colResultsIn.results{1,1};
    colResultsSparseMatlabImages = colResultsTMP(:,2);
    colResultsIn = load(colResultsOriginalDirectoryMatlab);
    colResultsTMP = colResultsIn.results{1,1};
    colResultsOriginalMatlabImages =colResultsTMP(:,2);
    colResultsIn = load(colResultsSparseDirectorygfpop);
    colResultsTMP = colResultsIn.results{1,1};
    colResultsSparsegfpopImages = colResultsTMP(:,2);
    colResultsIn = load(colResultsOriginalDirectorygfpop);
    colResultsTMP = colResultsIn.results{1,1};
    colResultsOriginalgfpopImages =colResultsTMP(:,2);

    % Loading Both Results
    bothResultsIn = load(bothResultsSparseDirectoryMatlab);
    bothResultsTMP = bothResultsIn.results{1,1};
    bothResultsSparseMatlabImages = bothResultsTMP(:,2);
    bothResultsIn = load(bothResultsSparseDirectorygfpop);
    bothResultsTMP = bothResultsIn.results{1,1};
    bothResultsSparsegfpopImages = bothResultsTMP(:,2);
    bothResultsIn = load(bothResultsOriginalDirectoryMatlab);
    bothResultsTMP = bothResultsIn.results{1,1};
    bothResultsOriginalMatlabImages = bothResultsTMP(:,2);
    bothResultsIn = load(bothResultsOriginalDirectorygfpop);
    bothResultsTMP = bothResultsIn.results{1,1};
    bothResultsOriginalgfpopImages = bothResultsTMP(:,2);
    

    % Creating Vectors for Confusion Matrix
    rowOriginalPredictedMatlab = logical(rowResultsOriginalMatlabImages);
    colOriginalPredictedMatlab = logical(colResultsOriginalMatlabImages);
    bothOriginalPredictedMatlab = logical(bothResultsOriginalMatlabImages);
    rowSparsePredictedMatlab = logical(rowResultsSparseMatlabImages);
    colSparsePredictedMatlab = logical(colResultsSparseMatlabImages);
    bothSparsePredictedMatlab = logical(bothResultsSparseMatlabImages);
    rowOriginalPredictedgfpop = logical(rowResultsOriginalgfpopImages);
    colOriginalPredictedgfpop = logical(colResultsOriginalgfpopImages);
    bothOriginalPredictedgfpop = logical(bothResultsOriginalgfpopImages);
    rowSparsePredictedgfpop = logical(rowResultsSparsegfpopImages);
    colSparsePredictedgfpop = logical(colResultsSparsegfpopImages);
    bothSparsePredictedgfpop = logical(bothResultsSparsegfpopImages);

    % Creating Confusion Matrix
    rowOriginalMatrixMatlab = confusionmat(imagesTrue,rowOriginalPredictedMatlab);
    colOriginalMatrixMatlab = confusionmat(imagesTrue,colOriginalPredictedMatlab);
    bothOriginalMatrixMatlab = confusionmat(imagesTrue,bothOriginalPredictedMatlab);
    rowSparseMatrixMatlab = confusionmat(imagesTrue,rowSparsePredictedMatlab);
    colSparseMatrixMatlab = confusionmat(imagesTrue,colSparsePredictedMatlab);
    bothSparseMatrixMatlab = confusionmat(imagesTrue,bothSparsePredictedMatlab);
    rowOriginalMatrixgfpop = confusionmat(imagesTrue,rowOriginalPredictedgfpop);
    colOriginalMatrixgfpop = confusionmat(imagesTrue,colOriginalPredictedgfpop);
    bothOriginalMatrixgfpop = confusionmat(imagesTrue,bothOriginalPredictedgfpop);
    rowSparseMatrixgfpop = confusionmat(imagesTrue,rowSparsePredictedgfpop);
    colSparseMatrixgfpop = confusionmat(imagesTrue,colSparsePredictedgfpop);
    bothSparseMatrixgfpop = confusionmat(imagesTrue,bothSparsePredictedgfpop);

    % Analyzing and Combining Matrices
   if(imagesTrue == rowOriginalPredictedMatlab)
        rowOriginalMatrixMatlab = [(sum(imagesTrue(:)) == 0)*rowOriginalMatrixMatlab 0 ; 0 (sum(imagesTrue(:)) == 1)*rowOriginalMatrixMatlab];
    end

    if(imagesTrue == colOriginalPredictedMatlab)
        colOriginalMatrixMatlab = [(sum(imagesTrue(:)) == 0)*colOriginalMatrixMatlab 0 ; 0 (sum(imagesTrue(:)) == 1)*colOriginalMatrixMatlab];
    end

    if(imagesTrue == bothOriginalPredictedMatlab)
        bothOriginalMatrixMatlab = [(sum(imagesTrue(:)) == 0)*bothOriginalMatrixMatlab 0 ; 0 (sum(imagesTrue(:)) == 1)*bothOriginalMatrixMatlab];
    end

    if(imagesTrue == rowSparsePredictedMatlab)
        rowSparseMatrixMatlab = [(sum(imagesTrue(:)) == 0)*rowSparseMatrixMatlab 0 ; 0 (sum(imagesTrue(:)) == 1)*rowSparseMatrixMatlab];
    end

    if(imagesTrue == colSparsePredictedMatlab)
        colSparseMatrixMatlab = [(sum(imagesTrue(:)) == 0)*colSparseMatrixMatlab 0 ; 0 (sum(imagesTrue(:)) == 1)*colSparseMatrixMatlab];
    end

    if(imagesTrue == bothSparsePredictedMatlab)
        colSparseMatrixMatlab = [(sum(imagesTrue(:)) == 0)*bothSparseMatrixMatlab 0 ; 0 (sum(imagesTrue(:)) == 1)*bothSparseMatrixMatlab];
    end

    if(imagesTrue == rowOriginalPredictedgfpop)
        rowOriginalMatrixgfpop = [(sum(imagesTrue(:)) == 0)*rowOriginalMatrixgfpop 0 ; 0 (sum(imagesTrue(:)) == 1)*rowOriginalMatrixgfpop];
    end

    if(imagesTrue == colOriginalPredictedgfpop)
        colOriginalMatrixgfpop = [(sum(imagesTrue(:)) == 0)*colOriginalMatrixgfpop 0 ; 0 (sum(imagesTrue(:)) == 1)*colOriginalMatrixgfpop];
    end

    if(imagesTrue == bothOriginalPredictedgfpop)
        bothOriginalMatrixgfpop = [(sum(imagesTrue(:)) == 0)*bothOriginalMatrixgfpop 0 ; 0 (sum(imagesTrue(:)) == 1)*bothOriginalMatrixgfpop];
    end

    if(imagesTrue == rowSparsePredictedgfpop)
        rowSparseMatrixgfpop = [(sum(imagesTrue(:)) == 0)*rowSparseMatrixgfpop 0 ; 0 (sum(imagesTrue(:)) == 1)*rowSparseMatrixgfpop];
    end

    if(imagesTrue == colSparsePredictedgfpop)
        colSparseMatrixgfpop = [(sum(imagesTrue(:)) == 0)*colSparseMatrixgfpop 0 ; 0 (sum(imagesTrue(:)) == 1)*colSparseMatrixgfpop];
    end

    if(imagesTrue == bothSparsePredictedgfpop)
        colSparseMatrixgfpop = [(sum(imagesTrue(:)) == 0)*bothSparseMatrixgfpop 0 ; 0 (sum(imagesTrue(:)) == 1)*bothSparseMatrixgfpop];
    end

    totalRowResultsOriginalMatlab = totalRowResultsOriginalMatlab + rowOriginalMatrixMatlab;
    totalColResultsOriginalMatlab = totalColResultsOriginalMatlab + colOriginalMatrixMatlab;
    totalBothResultsOriginalMatlab = totalBothResultsOriginalMatlab + bothOriginalMatrixMatlab;
    totalRowResultsSparseMatlab = totalRowResultsSparseMatlab + rowSparseMatrixMatlab;
    totalColResultsSparseMatlab = totalColResultsSparseMatlab + colSparseMatrixMatlab;
    totalBothResultsSparseMatlab = totalBothResultsSparseMatlab + bothSparseMatrixMatlab;
    totalRowResultsOriginalgfpop = totalRowResultsOriginalgfpop + rowOriginalMatrixgfpop;
    totalColResultsOriginalgfpop = totalColResultsOriginalgfpop + colOriginalMatrixgfpop;
    totalBothResultsOriginalgfpop = totalBothResultsOriginalgfpop + bothOriginalMatrixgfpop;
    totalRowResultsSparsegfpop = totalRowResultsSparsegfpop + rowSparseMatrixgfpop;
    totalColResultsSparsegfpop = totalColResultsSparsegfpop + colSparseMatrixgfpop;
    totalBothResultsSparsegfpop = totalBothResultsSparsegfpop + bothSparseMatrixgfpop;

end
end

figure(1); clf;
subplot(131); fullRowMatrixOriginalMatlab = confusionchart(totalRowResultsOriginalMatlab,{'no bee' 'bee'}); title('Rows - Original - Matlab');
save("totalRowResultsOriginalMatlab.mat","fullRowMatrixOriginalMatlab");
subplot(132); fullColMatrixOriginalMatlab = confusionchart(totalColResultsOriginalMatlab,{'no bee' 'bee'}); title('Cols - Original - Matlab');
save("totalColResultsOriginal.matMatlab","fullColMatrixOriginalMatlab");
subplot(133); fullBothMatrixOriginalMatlab = confusionchart(totalBothResultsOriginalMatlab,{'no bee' 'bee'}); title('Both - Original - Matlab');
save("totalBothResultsOriginal.matMatlab","fullBothMatrixOriginalMatlab");
figure(2); clf;
subplot(131); fullRowMatrixSparseMatlab = confusionchart(totalRowResultsSparseMatlab,{'no bee' 'bee'}); title('Rows - Sparse - Matlab');
save("totalRowResultsSparseMatlab.mat","fullRowMatrixSparseMatlab");
subplot(132); fullColMatrixSparseMatlab = confusionchart(totalColResultsSparseMatlab,{'no bee' 'bee'}); title('Cols - Sparse - Matlab');
save("totalColResultsSparseMatlab.mat","fullColMatrixSparseMatlab");
subplot(133); fullBothMatrixSparseMatlab = confusionchart(totalBothResultsSparseMatlab,{'no bee' 'bee'}); title('Both - Sparse - Matlab');
save("totalBothResultsSparseMatlab.mat","fullBothMatrixSparseMatlab");
figure(3); clf;
subplot(131); fullRowMatrixOriginalgfpop = confusionchart(totalRowResultsOriginalgfpop,{'no bee' 'bee'}); title('Rows - Original - gfpop');
save("totalRowResultsOriginal.mat","fullRowMatrixOriginalgfpop");
subplot(132); fullColMatrixOriginalgfpop = confusionchart(totalColResultsOriginalgfpop,{'no bee' 'bee'}); title('Cols - Original - gfpop');
save("totalColResultsOriginal.mat","fullColMatrixOriginalgfpop");
subplot(133); fullBothMatrixOriginalgfpop = confusionchart(totalBothResultsOriginalgfpop,{'no bee' 'bee'}); title('Both - Original - gfpop');
save("totalBothResultsOriginal.mat","fullBothMatrixOriginalgfpop");
figure(4); clf;
subplot(131); fullRowMatrixSparsegfpop = confusionchart(totalRowResultsSparsegfpop,{'no bee' 'bee'}); title('Rows - Sparse - gfpop');
save("totalRowResultsSparsegfpop.mat","fullRowMatrixSparsegfpop");
subplot(132); fullColMatrixSparsegfpop = confusionchart(totalColResultsSparsegfpop,{'no bee' 'bee'}); title('Cols - Sparse - gfpop');
save("totalColResultsSparsegfpop.mat","fullColMatrixSparsegfpop");
subplot(133); fullBothMatrixSparsegfpop = confusionchart(totalBothResultsSparsegfpop,{'no bee' 'bee'}); title('Both - Sparse - gfpop');
save("totalBothResultsSparsegfpop","fullBothMatrixSparsegfpop");