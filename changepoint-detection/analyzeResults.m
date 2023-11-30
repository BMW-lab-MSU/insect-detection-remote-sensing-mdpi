% SPDX-License-Identifier: BSD-3-Clause
function [confMat,accuracy,recall] = analyzeResults(predicted,true)

    confMat = confusionmat(true,predicted);
    accuracy = 0;
    recall = 0;

end