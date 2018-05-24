function s = cleanStr(s)
%CLEANSTR remove leading and trailing blanks from character string
%   S = CLEANSTR(S) removes leading and trailing blanks from character string S and substitutes multiple spaces
%   for single space. Double quotes are also removed. 
%
%   C = CLEANSTR(C), when C is a cell-array of strings, every element of C is cleaned.

%B. Van de Sande 22-07-2003

%Bij cell-array of strings de functie iteratief aanroepen voor elk element ...
if iscellstr(s), 
    N = length(s);
    for n = 1:N, s{n} = cleanStr(s{n}); end
    return;
end
    
%Spaties verwijderen in het begin en aan het einde van de teken reeks ...
idx = find(~isspace(s)); 

idx_start = min(idx);
idx_end = max(idx);

s = s(idx_start:idx_end);

%Multipele spaties vervangen door een enkele spatie ...
idx = idx - idx_start + 1;
d_idx = find(diff(idx) > 2);
if ~isempty(d_idx), idx = idx(d_idx)+2:idx(d_idx+1)-1; s(idx) = []; end

%Dubbele aanhalingstekens steeds verwijderen ... Vooral nodig om TAB-delimited conversies van Excel spreadsheets
%goed in te kunnen laden ...
idx = findstr(s, '"'); s(idx) = [];