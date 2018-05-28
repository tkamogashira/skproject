function Str = spl2Str(ds)
%spl2Str   converts dataset SPL to character string
%   Str = spl2Str(ds)

SPL = GetSPL(ds); NRec = ds.nrec;
LeSPL = denan(unique(SPL(1:NRec, 1)));
ReSPL = denan(unique(SPL(1:NRec, end)));

if isempty(LeSPL) || isempty(ReSPL)
    Str = 'N/A';
elseif (length(LeSPL) > 1) || (length(ReSPL) > 1)
    Str = 'Varied';
elseif isequal(LeSPL, ReSPL)
    Str = sprintf('%d (dB)', LeSPL);
else
    Str = sprintf('[%d %d] (dB)', LeSPL, ReSPL);
end
