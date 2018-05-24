function Struct = AssignStruct(Struct1, Struct2)

Struct = struct([]);

FNames1 = fieldnames(Struct1);
FNames2 = fieldnames(Struct2);
if length(FNames1) ~= length(FNames2), return; end

NFields = length(FNames1);
NElem   = length(Struct2);

for N = 1:NElem
    for FieldNr = 1:NFields
        Value  = getfield(Struct2, {N}, FNames2{FieldNr});
        Struct = setfield(Struct, {N}, FNames1{FieldNr}, Value);
    end
end    