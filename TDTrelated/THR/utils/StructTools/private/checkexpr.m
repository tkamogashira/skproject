function boolean = CheckExpr(Str, ValidFNames)

%B. Van de Sande 21-05-2005

%Check input arguments ...
if (nargin ~= 2), error('Wrong number of input arguments.'); end
if ~ischar(Str) | ~any(size(Str, 1) == [0, 1]), error('First argument should be character string with expression.'); end
if ~ischar(ValidFNames) & ~iscellstr(ValidFNames), error('Second argument should be cell-array of strings with valid fieldnames for expression.'); end

%Check validity of expression ...
boolean = logical(1); %Optimistic approach ...
try, ParseExpr(Str, ValidFNames);
catch, lasterr(''); boolean = logical(0); end