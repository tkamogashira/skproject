function expr = parseExpr(Str, ValidFNames)

% B. Van de Sande 13-08-2005
% Adjusted by Kevin, 06-03-2007

%Check input arguments ...
if (nargin ~= 2)
    error('Wrong number of input arguments.'); 
end
if ~ischar(Str) | ~any(size(Str, 1) == [0, 1]) %#ok<OR2>
    error('First argument should be character string with expression.'); 
end
if ~ischar(ValidFNames) & ~iscellstr(ValidFNames)
    error('Second argument should be cell-array of strings with valid fieldnames for expression.'); 
end
ValidFNames = cellstr(ValidFNames);    

%Search for dollar signs in expression ...
DolSidx = find(Str == '$');
if (rem(length(DolSidx), 2) ~= 0)
    error('Dollar signs should always match up.'); 
end
DolSidx = reshape(DolSidx, 2, length(DolSidx)/2)';

%Check fieldnames present in expression and create semi-parsed version of expression ...
NFields = size(DolSidx, 1); 
if (NFields == 0)
    if isempty(str2num(Str)) %#ok<ST2NM>
        FName = Str; idx = find(ismember(ValidFNames, FName));
        if isempty(idx)
            error(sprintf('''%s'' is not a valid fieldname.', FName));  %#ok<SPERR> 
        end
        expr = {idx};
    else
        expr = {Str}; 
    end
else
    expr = cell(0); PrevIdx = 1;
    for n = 1:NFields
        FName = Str(DolSidx(n, 1)+1:DolSidx(n, 2)-1); idx = find(ismember(ValidFNames, FName));
        if isempty(idx)
            error(sprintf('''%s'' is not a valid fieldname.', FName));  %#ok<SPERR> 
        end
        expr = [expr, {Str(PrevIdx:DolSidx(n, 1)-1), idx}]; PrevIdx = DolSidx(n, 2)+1;
    end 
    expr = [expr, {Str(DolSidx(end, 2)+1:end)}];
    expr(cellfun('isempty', expr)) = [];
end