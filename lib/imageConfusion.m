function [confmat,trueImageLabels,predictedImageLabels] = imageConfusion(predicted, target)

if isa(predicted,"categorical")
    % Convert from categorical to logical so we can use any() later
    predicted = predicted == "true";
    target = target == "true";
end

% SPDX-License-Identifier: BSD-3-Clause

nImages = numel(predicted)/178;

predictedLabelsCell = mat2cell(predicted, 178*ones(1,nImages), 1);
trueLabelsCell = mat2cell(target, 178*ones(1,nImages),1);


% get vectors of image labels
trueImageLabels = cellfun(@(c) any(c), trueLabelsCell);
predictedImageLabels = cellfun(@(c) any(c), predictedLabelsCell);
confmat = confusionmat(trueImageLabels, predictedImageLabels);
