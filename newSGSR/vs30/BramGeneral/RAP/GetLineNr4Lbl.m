function LineNr = GetLineNr4Lbl(Tbl, LblID)
%GetLineNr4Lbl   translates label ID to line number
%   LineNr = GetLineNr4Lbl(Tbl, LblID)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 20-02-2004

if ~isempty(Tbl),
    idx = find(strcmpi(Tbl(:, 1), LblID));
    if ~isempty(idx), LineNr = Tbl{idx, 2}; 
    else, LineNr = NaN; end
else, LineNr = NaN; end