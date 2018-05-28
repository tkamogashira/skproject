function S = StructSort(varargin)
%STRUCTSORT sort structure array.
%   S = STRUCTSORT(S, FieldName) sorts structure S by fieldname FieldName. 
%   FieldName can be a cell-array of fieldnames. For branched structures 
%   fieldnames can be given using the dot as a fieldname separator.
%   Moreover fieldnames my contain arithmetic expressions. Any MATLAB
%   expression that returns a vector with the same number of elements in
%   a field is valid. Fieldnames in these expressions must be enclosed
%   between dollar signs.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   See also STRUCTVIEW, STRUCTDISP, STRUCTFILTER, STRUCTMERGE, STRUCTFIELD and
%   STRUCTPLOT.
%
%   Additional tools that can be used for expressions are GETCOLUMN, FINDPATTERN
%   and FINDELEMENT.

%B. Van de Sande 21-02-2005

%-----------------------------default parameters-----------------------------
DefParam.mode = 'asc'; %Asc(ending) or desc(ending) ...

%------------------------------main program-----------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    if (nargout == 0), disp('Properties and their factory defaults:'); disp(DefParam);
    else, ArgOut = DefParam; end
    return;
elseif (nargin < 2), error('Wrong number of input arguments.');
else,
    [S, Expr] = deal(varargin{1:2});
    if ~isstruct(S), error('First argument should be structure.'); end
    if ~ischar(Expr) & ~iscellstr(Expr), error('Second argument should be fieldname or arithmetic expression to sort by.'); 
    else, Expr = cellstr(Expr); end
    
    Param = checkproplist(DefParam, varargin{3:end});
    if ~any(strncmpi(Param.mode, {'a', 'd'}, 1)), error('Invalid value for property mode.'); end
end

%Extract the columns to sort by ...
D = ExtractData(S, Expr);

%Actual sorting ...
P = SortData(D);

%If sorting in descending order is requested ...
if strncmpi(Param.mode, 'd', 1), P = P(end:-1:1); end

S = S(P); 

%-----------------------------local functions---------------------------------
function D = ExtractData(S, Expr) 

NElem = length(S); NExpr = length(Expr);
D = cell(NElem, NExpr);

[Data, FNames] = destruct(S);

for n = 1:NExpr,
    Value = evalexpr(parseExpr(Expr{n}, FNames), Data);
    
    if iscellstr(Value), D(:, n) = Value;
    else, D(:, n) = num2cell(Value, 2); end
end

%-----------------------------------------------------------------------------
function P = SortData(D)

%First sort by least significant field or expression, because sorting algorithm
%doesn't change order for similar entries ...
[NElem, NCols] = size(D); P = 1:NElem;
for n = NCols:-1:1,
    if all(cellfun('isclass', D(:, n), 'double')), [dummy, idx] = sort(cat(2, D{:, n}));
    else, [dummy, idx] = sort(D(:, n)); end
    D = D(idx, :); P = P(idx);
end

%-----------------------------------------------------------------------------