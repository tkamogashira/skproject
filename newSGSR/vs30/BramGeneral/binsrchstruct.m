function [Found, idx] = binsrchstruct(S, FieldName, TargetValue)
%BINSRCHSTRUCT  binary search a sorted structure array
%   [Found, idx] = BINSRCHSTRUCT(S, FieldName, TargetValue) searches structure array S sorted by unique fieldname
%   FieldName for the item where that fieldname is equal to TargetValue. If such an item exists, then Found will
%   be 1 and the index of that specific item will be idx. Otherwise Found will be zero and idx will be the index
%   of the item where FieldName has a value just lower than TargetValue.

%B. Van de Sande 24-03-2003

BottomNr = 1;
TopNr    = length(S);
Found    = logical(0);

while (~Found) & (TopNr >= BottomNr)
    MidNr = floor((TopNr + BottomNr)/2);
    Value = getfield(S, {MidNr}, FieldName);
    if Compare('=', TargetValue, Value), 
        Found = logical(1);
    elseif Compare('<', TargetValue, Value)
        TopNr = MidNr - 1;
    else
        BottomNr = MidNr + 1;
    end
end    

if ~Found, idx = TopNr;
else, idx = MidNr; end
