function str = nospace(str);
% NOSPACE - remove all whitespace from string
if ~ischar(str), return; end;
if isempty(str), return; end;

fSP = find(isspace(str));
if ~isempty(fSP), str(fSP) = ''; end;

