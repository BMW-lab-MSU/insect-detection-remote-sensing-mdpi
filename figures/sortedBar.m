function [barHandle,fig,ax] = sortedBar(values,locationsOrNames,opts)
arguments
    values (1,:) {mustBeNumeric}
    locationsOrNames (1,:) {mustBeSameSizeOrEmpty(locationsOrNames,values),mustBeNumericOrString(locationsOrNames)} = []
    opts.Horizontal (1,1) logical = true
    opts.FaceColor (1,3) double = [0 0.4470 0.7410] % default MATLAB blue
    opts.FaceAlpha (1,1) double {mustBeInRange(opts.FaceAlpha,0,1)} = 1
    opts.EdgeColor (1,3) double = [0 0 0]
    opts.EdgeAlpha (1,1) double {mustBeInRange(opts.EdgeAlpha,0,1)} = 0
    opts.BarWidth (1,1) double {mustBeInRange(opts.BarWidth,0,1)} = 0.9
    opts.LineWidth (1,1) double = 1
    opts.ShowValuesInBars (1,1) logical = true;
    opts.ValueFormat (1,1) string = "%.3f";
    opts.ValueOffset (1,1) double = 0.02;
    opts.ValueFontColor (1,3) double = [1 1 1]
    opts.ValueFontWeight (1,1) string = "bold"
    opts.ValueFontSize (1,1) {mustBeInteger} = 14
    opts.LabelFontSize (1,1) {mustBeInteger} = get(groot, 'defaultAxesFontSize')
    opts.FontName (1,1) string = get(groot, 'defaultAxesFontName')
    opts.SortDirection = "descend"
end

% Sort the values
[sortedValues,sortIdx] = sort(values,opts.SortDirection);

if ~isempty(locationsOrNames)
    sortedLocationsOrNames = locationsOrNames(sortIdx);
end

% Create the bar plot
fig = figure();

barHandle = bar(sortedValues,...
    Horizontal=opts.Horizontal,...
    FaceColor=opts.FaceColor,...
    FaceAlpha=opts.FaceAlpha,...
    EdgeColor=opts.EdgeColor,...
    EdgeAlpha=opts.EdgeAlpha,...
    LineWidth=opts.LineWidth,...
    BarWidth=opts.BarWidth);

ax = gca;

% Reverse the y-axis direction because the horizontal bar chart sorts by
% indices in *descending* order, which makes everything backwards.
if opts.Horizontal
    ax.YDir = "reverse";
end

% Set the y/x tick labels to the sorted locations or names
if ~isempty(locationsOrNames)
    if opts.Horizontal
        yticklabels(sortedLocationsOrNames);
    else
        xticklabels(sortedLocationsOrNames);
    end
end

% Turn off axis box for prettiness :) You can always change this outside of the function.
box off

% Set axis limits to tight for prettiness :)
ax.YLimitMethod="tight";
ax.XLimitMethod="tight";


if opts.ShowValuesInBars
    % Format each value as a string, using the printf format specified in opts.ValueFormat
    strValues = arrayfun(@(s) num2str(s, opts.ValueFormat),barHandle.YData,...
        UniformOutput=false);

    % Put the values in the bars. The values are centered in the bar, and appear towards
    % the bottom (or left side) of the bars. The distance away from the bottom/left is
    % controlled by opts.ValueOffset.
    if opts.Horizontal
        xLocations = opts.ValueOffset * ones(size(values));
        yLocations = barHandle.XEndPoints;

        text(xLocations,yLocations,strValues,...
            HorizontalAlignment="left",VerticalAlignment="middle",...
            FontSize=opts.ValueFontSize,FontWeight=opts.ValueFontWeight,...
            Color=opts.ValueFontColor)
    else
        xLocations = barHandle.XEndPoints;
        yLocations = opts.ValueOffset * ones(size(values));

        text(xLocations,yLocations,strValues,...
            HorizontalAlignment="center",VerticalAlignment="baseline",...
            FontSize=opts.ValueFontSize,FontWeight=opts.ValueFontWeight,...
            Color=opts.ValueFontColor)
    end
end

end

function mustBeSameSizeOrEmpty(a,b)
% mustBeSameSizeOrEmpty Validate that the inputs are the same size or b is empty
    if isempty(a)
        return
    elseif ~isequal(size(a),size(b))
        eid = 'mustBeSameSizeOrEmpty:notSameSize';
        msg = 'Size of first input must equal size of second input.';
        throwAsCaller(MException(eid,msg));
    end
end

function mustBeNumericOrString(a)
% mustBeNumericOrString Validate that the input is number or a string
    if ~isnumeric(a) && ~isstring(a)
        eid = 'mustBeNumericOrString:notNumericOrString';
        msg = 'Input must be numeric or a string';
        throwAsCaller(MException(eid,msg));
    else
        return
    end
end
