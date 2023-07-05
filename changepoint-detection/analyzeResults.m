function [confMat,accuracy,recall] = analyzeResults(predicted,true,matrixTitle)

    figure();
    confMat = confusionchart(true,predicted); title(matrixTitle);
    accuracy = 0;
    recall = 0;

end