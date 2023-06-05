function [accuracy, precision, recall, f2, f3, mcc] = analyzeConfusion(confmat)

% confmat is a confusion matrix like so:
%
%                  predicted no fish    |  predicted fish
%                 ______________________|______________________
%                |                      |                      |
% actual no fish |  confmat(1,1) (TN)   |   confmat(1,2) (FP)  |
%                |                      |                      |
% actual fish    |  confmat(2,1) (FN)   |   confmat(2,2) (TP)  |
%                |______________________|______________________|

% SPDX-License-Identifier: BSD-3-Clause

TN = confmat(1,1);
FP = confmat(1,2);
FN = confmat(2,1);
TP = confmat(2,2);

accuracy = (TP + TN)/(TP + TN + FP + FN);
precision = (TP)/(TP + FP);
recall = (TP)/(TP + FN);
f2 = (1 + 2^2) * (precision * recall)/((2^2)*precision + recall);
f3 = (1 + 3^2) * (precision * recall)/((3^2)*precision + recall);
mcc = (TP * TN - FP * FN)/(sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN)));

end
