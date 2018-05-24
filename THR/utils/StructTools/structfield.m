function V = StructField(S, Expr)
%STRUCTFIELD    get column from structure-array.
%   V = STRUCTFIELD(S, FieldName) returns the field specified by the character
%   string FieldName in the cell-array V. A column containing only scalars is
%   converted to a numeric vector.  For branched structures fieldnames can be
%   given using the dot as a fieldname separator. Moreover fieldnames my contain
%   arithmetic expressions. Any MATLAB expression that returns a vector with the
%   same number of elements in a field is valid. Fieldnames in these expressions
%   must be enclosed between dollar signs.
%   
%   See also STRUCTSORT, STRUCTFILTER, STRUCTMERGE, STRUCTPLOT and STRUCTVIEW

%B. Van de Sande 11-03-2005

%Checking input parameters ...
if (nargin ~= 2) | ~isstruct(S) | ~ischar(Expr), error('Wrong input arguments.'); end

[Data, FNames] = destruct(S);
V = EvalExpr(ParseExpr(Expr, FNames), Data);
%Conversion to double vector not necessary becuase this is already done in EVALEXPR.M ...
%if all(cellfun('isclass', V, 'double') & (cellfun('size', V, 1) == 1)) & ...
%        (length(unique(cellfun('size', V, 2))) == 1), 
%    V = cat(1, V{:}); 
%end