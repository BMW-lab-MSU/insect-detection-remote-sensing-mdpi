function [confmat,trueImageLabels,predImageLabels] = imageConfusion(pred, target)

% SPDX-License-Identifier: BSD-3-Clause

nImages = numel(pred)/178;

predLabelsCell = mat2cell(pred, 178*ones(1,nImages), 1);
trueLabelsCell = mat2cell(target, 178*ones(1,nImages),1);


% get vectors of image labels
trueImageLabels = cellfun(@(c) any(c), trueLabelsCell);
predImageLabels = cellfun(@(c) any(c), predLabelsCell);
confmat = confusionmat(trueImageLabels, predImageLabels);
