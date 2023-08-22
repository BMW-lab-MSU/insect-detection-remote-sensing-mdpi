function tLayout = labelComparisonFig(labels, predictedLabels, cData, xData, yData, opts)
arguments
    labels (:,1) logical
    predictedLabels (:,1) logical
    cData (:,:) {mustBeNumeric}
    xData (:,1) {mustBeNumeric} = []
    yData (:,1) {mustBeNumeric} = []
    opts.DataLabelAspectRatio (1,1) {mustBeInteger} = 16
    opts.DataColormap = colormap
    opts.LabelColors (2,3) {mustBeInRange(opts.LabelColors,0,1)} = [0 0.4470 0.7410; 0.8500 0.3250 0.0980]
    opts.LabelNames = {'human labels', 'predicted labels'}
    opts.FontSize (1,1) {mustBeInteger} = get(groot, 'defaultAxesFontSize')
    opts.FontName (1,1) string = get(groot, 'defaultAxesFontName')
end

% SPDX-License-Identifier: BSD-3-Clause

[nRows,nCols] = size(cData);

if isempty(xData)
    xData = 1:nCols;
end
if isempty(yData)
    yData = 1:nRows;
end

% % force labels to be column vectors
% labels = labels(:);
% predictedLabels = predictedLabels(:);

tLayout = tiledlayout(1,opts.DataLabelAspectRatio,TileSpacing="none",Padding="compact");

% make the data image span the first DataLabelAspectRatio columns
nexttile(1,[1,opts.DataLabelAspectRatio - 1])
imagesc(xData, yData, cData);

% put the labels image in the last column at the far right
nexttile(opts.DataLabelAspectRatio)

% concatenate the labels together; one of the labels needs to be multiplied
% by something greater than 1 to make imagesc display the labels as different
% colors
labelsMatrix = [labels, 2*predictedLabels];
imagesc(0:1, yData, labelsMatrix);

% turn off label plot axes
labelAx = tLayout.Children(1);
labelAx.Visible = "off";

% turn off the axis box so the tick marks don't interfere with the labels
dataAx = tLayout.Children(2);
dataAx.Box = "off";
dataAx.FontName = opts.FontName;
dataAx.FontSize = opts.FontSize;

% link axes so zooming in the y-direction zooms for both the image and labels
linkaxes([dataAx, labelAx],'y');

% set colormaps for data and labels; white is added to labels colormap
% so the background is white.
% using multiple colormaps in a single figure:
% https://www.mathworks.com/matlabcentral/answers/194554-how-can-i-use-and-display-two-different-colormaps-on-the-same-figure
colormap(dataAx, opts.DataColormap);
colormap(labelAx, [1 1 1; opts.LabelColors]);

% add "fake" lines so we can have a legend for the label blocks
% https://stackoverflow.com/questions/12902709/how-to-add-legend-in-imagesc-plot-in-matlab
L = line(dataAx,ones(2),ones(2), 'LineWidth',2);
set(L,{'color'},mat2cell(opts.LabelColors,ones(1,2),3));

legendobj = legend(dataAx,opts.LabelNames);
legendobj.Location = "southeast";
legendobj.EdgeColor=[1 1 1];
legendobj.FontSize = opts.FontSize;
legendobj.FontName = opts.FontName;

% setting legend background alpha:
% https://undocumentedmatlab.com/articles/transparent-legend
set(legendobj.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.3]));
set(legendobj.BoxEdge, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.3]));
end