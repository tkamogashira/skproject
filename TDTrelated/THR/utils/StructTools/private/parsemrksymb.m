function [Sm, Srf] = ParseMrkSymb(Mrk)

%B. Van de Sande 11-04-2005

%Check input arguments ...
if (nargin ~= 1), error('Wrong number of input arguments.'); end
if ~iscellstr(Mrk), error('First argument should be cell-array of strings with marker symbols.'); end

%Parse marker symbols ...
Len = cellfun('length', Mrk); if ~all(ismember(Len, [1, 2, 4])), error('Invalid marker symbol syntax.'); end
Sidx = find(Len == 1 | Len == 4); 
if ~isempty(Sidx), Sm(Sidx) = Mrk(Sidx); Srf(Sidx) = {'u'}; end
Didx = find(Len == 2);
if ~isempty(Didx), Ch = char(Mrk(Didx)); Sm(Didx) = cellstr(Ch(:, 1)); Srf(Didx) = cellstr(Ch(:, 2)); end
if ~all(ismember(Sm, {'.', 'o', 'x', '+', '-', '*', '^', 'v', '<', '>', 'p', 'h', 'd', 's', 'none'})) | ...
   ~all(ismember(Srf, {'u', 'f', 'w'})), 
    error('Invalid marker symbol syntax.'); 
end