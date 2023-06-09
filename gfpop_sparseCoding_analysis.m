baseDir = "../data/raw";
dates = ["2022-06-23" "2022-06-24" "2022-07-28" "2022-07-29"];
folderPrefix = "MSU-horticulture-farm-bees-";
imageNum0623 = ["122126" "135615" "141253" "144154" "145241"];
imageNum0624 = ["094752" "095001" "104012" "105017" "110409" "111746" "113017" "114343"];
imageNum0728 = ["112652" "120850" "123948" "124905" "131133" "133834" "135906" "141427" "143013" "144821"];
imageNum0729 = ["090758" "093945" "095958" "101924"];
scanNumbers = {imageNum0623, imageNum0624, imageNum0728, imageNum0729};
rowResultsInput = "rowResults.mat";
colResultsInput = "colResults.mat";
labelsName = "labels.mat";

% Matrix Initialization
totalRowResults = [0 0 ; 0 0];
totalColResults = [0 0 ; 0 0];

% Folder Setup
for index = 1:length(dates)
date = dates(index);
scanNums = scanNumbers{index};
for scanNum = 1:length(scanNums)
rowResultsDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + rowResultsInput;
colResultsDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + rowResultsInput;
labelsDirectory = baseDir + filesep + date + filesep + folderPrefix + scanNums(scanNum) + filesep + labelsName;

    % Loading Image Labels
    labelsIn = load(labelsDirectory);
    imagesTrue = labelsIn.imageLabels;

    % Loading Row Results
    rowResultsIn = load(rowResultsDirectory);
    rowResultsTMP = rowResultsIn.results{1,1};
    rowResults = rowResultsTMP(:,2);

    % Loading Column Results
    colResultsIn = load(colResultsDirectory);
    colResultsTMP = colResultsIn.results{1,1};
    colResults = colResultsTMP(:,2);

    % Creating Vectors for Confusion Matrix
    rowPredicted = logical(rowResults);
    colPredicted = logical(colResults);
    % rowPredicted = zeros(1,length(imagesTrue));
    % colPredicted = zeros(1,length(imagesTrue));
    % 
    % rowPredicted(~isnan([rowResults.image])) = 1;
    % rowPredicted = logical(rowPredicted);
    % 
    % colPredicted(~isnan([colResults.image])) = 1;
    % colPredicted = logical(colPredicted);

    % Creating Confusion Matrix
    rowMatrix = confusionmat(imagesTrue,rowPredicted);
    colMatrix = confusionmat(imagesTrue,colPredicted);

    % Analyzing and Combining Matrices
    if(imagesTrue == rowPredicted)
        rowMatrix = [(sum(imagesTrue(:)) == 0)*rowMatrix 0 ; 0 (sum(imagesTrue(:)) == 1)*rowMatrix];
    end

    if(imagesTrue == colPredicted)
        colMatrix = [(sum(imagesTrue(:)) == 0)*colMatrix 0 ; 0 (sum(imagesTrue(:)) == 1)*colMatrix];
    end
    totalRowResults = totalRowResults + rowMatrix;
    totalColResults = totalColResults + colMatrix;

end
end

fullRowMatrix = confusionchart(totalRowResults,{'no bee' 'bee'});
save("totalRowResults.mat","fullRowMatrix");
fullColMatrix = confusionchart(totalColResults,{'no bee' 'bee'});
save("totalColResults.mat","fullColMatrix");