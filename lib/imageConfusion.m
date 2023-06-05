function [confmat,trueImageLabels,predImageLabels] = imageConfusion(pred, target, partition)

% SPDX-License-Identifier: BSD-3-Clause

predLabelsCell = mat2cell(pred, 178*ones(1,numel(pred)/178), 1);


% get vectors of image labels
trueImageLabels = cellfun(@(c) any(c), target);
predImageLabels = cellfun(@(c) any(c), predLabelsCell);
confmat = confusionmat(trueImageLabels, predImageLabels);
