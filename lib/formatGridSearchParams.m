function [grid] = formatGridSearchParams(params)
% formatGridSearchParams format parameter ranges for use with a grid search
%
%   Given a set of parameter ranges, create a grid of those parameters that can
%   be used in a linearly-indexed grid search with a single for-loop, i.e.
%   
%   for i = 1:gridSize
%       grid(i,:).param1 ...
%       grid(i,:).param2 ...
%   
%   where grid(i,:).paramX is the value of paramX at grid index i. The grid
%   is linearly-indexed for all parameters, allowing the grid search to be
%   done with one for loop, rather than nested loops.
%
%   grid = formatGridSearchParams(params) returns a table, called grid,
%   containing the parameter values for each grid index. params is a scalar
%   struct containing a field for each of the parameters to be used in the
%   grid search. Each field is an array of the parameter values.
%
%   See also ndgrid, table

% SPDX-License-Identifier: BSD-3-Clause
arguments
    params (1,1) struct
end

paramNames = fieldnames(params);

nParams = numel(paramNames);

% Convert struct to cell array so we can pass the parameter vectors to ndgrid
paramsCell = struct2cell(params);

% Found the idea for assigning multiple outputs to a cell array from here:
% https://stackoverflow.com/questions/15523851/how-to-pass-multiple-output-from-function-into-cell-array
[tmpNdGrid{1:nParams}] = ndgrid(paramsCell{:});

gridSize = numel(tmpNdGrid{1});

% We convert the cell array into a gridSize x nParams matrix since this is
% easy to convert into a table.
linearGridCoords = zeros(gridSize, nParams);

% Reshape each ndgrid coordinate matrix to a linearly-indexed vector. We put
% the vectors into columns of a matrix since that matrix can be directly convereted
% to a table with the parameters names as the table variable names.
for paramNum = 1:nParams
    linearGridCoords(:,paramNum) = reshape(tmpNdGrid{paramNum}, gridSize, 1);
end

% Create the grid search table. Note that we use tables here instead of an array of structs
% because the table is more memory-efficient. The one downside is that indexing into the table
% is more cumbersome than indexing into the array of structs, e.g. T(i,:).param1 vs. S(i).param1
grid = array2table(linearGridCoords, VariableNames=paramNames);

end
