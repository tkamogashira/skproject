function Txt = timeVar2Str(DurVec)
%timeVar2Str   converts time variable to character string
%   Str = timeVar2Str(DurVec)

if (length(DurVec) == 1) || ((length(DurVec) == 2) && isequal(DurVec(1), DurVec(2)))
    Txt = sprintf('%.0f ms', DurVec(1));
else
    Txt = sprintf('[%.0f %.0f] (ms)', DurVec);
end
