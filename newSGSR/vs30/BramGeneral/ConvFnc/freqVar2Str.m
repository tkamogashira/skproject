function Txt = freqVar2Str(FreqVec)
%freqVar2Str   converts frequency variable to character string
%   Str = freqVar2Str(DurVec)

if all(isnan(FreqVec(:)))
    Txt = 'N/A';
elseif (length(FreqVec) == 1) || (isequal(size(FreqVec), [1,2]) ...
        && isequal(FreqVec(1), FreqVec(2))) || (length(unique(FreqVec)) == 1)
    Txt = sprintf('%.0f Hz', FreqVec(1));
elseif isequal(size(FreqVec), [1,2])
    Txt = sprintf('[%.0f %.0f] (Hz)', FreqVec); 
elseif (size(FreqVec, 2) == 1)
    Txt = sprintf('[%.0f ... %.0f] (Hz)', min(FreqVec), max(FreqVec)); 
else
    Txt = sprintf('[%.0f %.0f ... %.0f %.0f] (Hz)', min(FreqVec, [], 1), max(FreqVec, [], 1)); 
end
