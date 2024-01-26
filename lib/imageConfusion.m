function [confmat,trueImageLabels,predictedImageLabels] = imageConfusion(predicted, target)
% imageConfusion agglomerate row labels into an image-based confusion matrix.
%
%   [confmat,trueImageLabels,predictedImageLabels] = ...
%       imageConfusion(predicted,target)
%   takes row-based predicted labels and target labels and then returns an
%   image-based confusion matrix, along with true and predicted image labels.

% SPDX-License-Identifier: BSD-3-Clause

% Convert from categorical to logical so we can use any() later
if isa(predicted,"categorical")
    predicted = predicted == "true";
end
if isa(target,"categorical")
    target = target == "true";
end

% TODO: don't hardcode the number of rows in each image (178, as of now).
nImages = numel(predicted)/178;

predictedLabelsCell = mat2cell(predicted, 178*ones(1,nImages), 1);
trueLabelsCell = mat2cell(target, 178*ones(1,nImages),1);


% get vectors of image labels
trueImageLabels = cellfun(@(c) any(c), trueLabelsCell);
predictedImageLabels = cellfun(@(c) any(c), predictedLabelsCell);
confmat = confusionmat(trueImageLabels, predictedImageLabels);
