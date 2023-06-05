function out = structFieldAppend(in1,in2)
%essentially just concatenates two structs

out=struct();
fields1=fieldnames(in1);
fields2=fieldnames(in2);

for i=1:length(fields1)
    if iscategorical(in1.(char(fields1(i))))
        in1.(char(fields1(i)))=char(in1.(char(fields1(i))));
    end
    out.(char(fields1(i)))=in1.(char(fields1(i)));
end

for i=1:length(fields2)
    if iscategorical(in2.(char(fields2(i))))
        in1.(char(fields2(i)))=char(in2.(char(fields2(i))));
    end
    out.(char(fields2(i)))=in2.(char(fields2(i)));
end


end