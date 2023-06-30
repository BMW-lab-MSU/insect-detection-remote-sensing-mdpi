function out = mergeStructs(in)
% mergeStructs merge scalar structures together into one struct
%
%   out = mergeStructs(in1,in2,in3,in4,...) merges all the input structs
%   together into the output struct, out.
%
%   mergeStructs supports any number of input structures. Any fields that are
%   in multiple structs will be overwritten; for common fields, the last input
%   struct with that field takes precedence, e.g., in3.field1 will replace
%   in1.field1. Only scalar structures are supported.

% SPDX-License-Identifier: BSD-3-Clause
arguments (Repeating)
    in (1,1) struct
end

% Initialize output struct with the first struct. We will merge
% all other structs into the first struct.
out = in{1};

% Determine how many structs we received as input
nStructs = numel(in);

% Get the field names for each struct
% NOTE: we don't actually need the field names for the first struct,
% but the indexing is a bit simpler this way.
fields = cell(1,nStructs);

for structNum = 1:nStructs
    fields{structNum} = fieldnames(in{structNum});
end

% Merge all structs into the first struct, overwritting
% any duplicate fields along the way. We use dynamic field
% names to address the struct fields and to create new fields
% in the first struct.
for structNum = 2:nStructs
    for fieldNum = 1:numel(fields{structNum})
        out.(fields{structNum}{fieldNum}) = in{structNum}.(fields{structNum}{fieldNum});
    end
end
end
