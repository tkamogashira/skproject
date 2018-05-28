function Str = freq2Str(Freq)

MaxNElem = 4; 
HMaxNElem = round(MaxNElem/2);

Freq = cleanStr(cellstr(num2str(Freq(:)))); 
NElem = length(Freq);

if (NElem > MaxNElem)
    Str = ['[', formatcell(Freq(1:HMaxNElem), {'', ''}, ','), ',...,', ...
            formatcell(Freq(NElem-HMaxNElem+1:end), {'', ''}, ','), '] Hz' ];
else
    Str = ['[' formatcell(Freq, {'', ''}, ',') '] Hz' ]; 
end

