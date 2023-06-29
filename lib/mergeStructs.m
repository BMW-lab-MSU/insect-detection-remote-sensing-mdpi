function out = mergeStructs(in)
    arguments (Repeating)
        in (1,1) struct
    end

    % Initialize output struct with the first struct. We will merge
    % all other structs into the first struct.
    out = in{1};

    % Determine how many structs we received as input
    nStructs = numel(in);

    % Get the field names for each struct
    % TODO: we don't actually need the field names for the first struct.
    fields = cell(1,nStructs);

    for strutNum = 1:nStructs
        fields{structNum} = fieldnames(in{structNum});
    end

    % Merge all structs into the first struct, overwritting
    % any duplicate fields along the way. We use dynamic field
    % names to address the struct fields and to create new fields
    % in the first struct.
    for structNum = 2:nStructs
        for fieldNum = 1:numel(fields{structNum})
            out.(fields{fieldNum}) = in{structNum}.(fields{fieldNum});
        end
    end
end
