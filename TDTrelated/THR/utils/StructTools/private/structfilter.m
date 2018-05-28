function S = structfilter(S, varargin)
%STRUCTFILTER filter structure-array
%   S = STRUCTFILTER(S, F1, V1, F2, V2, ...) reduces the structure-array S to only those elements
%   in which fieldname F1 has value V1 and fieldname F2 has value V2, ... For branched structures
%   fieldnames can be given using the dot as a fieldname separator.
%
%   S = STRUCTFILTER(S, C) reduces the structure-array S to only those elements which correspond to
%   the logical expression given by the string C. Fieldnames of the structure in this expresion must
%   be enclosed between dollar signs and they can be given recursively.
%
% See also STRUCTSORT

%B. Van de Sande 01-09-2003

%Parameters nagaan ...
if (nargin < 1), error('Wrong number of input parameters.'); end
if ~isstruct(S), error('First argument should be structure-array.'); end

%FILTER via logische expressie (slechts gedeeltelijke parsing)...
if (nargin == 2) & ischar(varargin{1}) & (ndims(varargin{1}) == 2) & any(size(varargin{1}) == 1),
    %Gegevens herorganiseren ...
    [C, F] = destruct(S);
    
    Exp = varargin{1}; [FieldNames, Exp] = local_parse(Exp);
    if ~all(ismember(FieldNames, F)), error('One of the fieldnames in the expression is not valid.'); end
    
    NFields = length(FieldNames); NElem = size(C, 1);
    Vec = cell(NElem, NFields); VecNames = cell(1, NFields);
    for n = 1:NFields,
        Fidx = find(ismember(F, FieldNames{n}));
        Vec(:, n) = C(:, Fidx);
        VecNames{n} = sprintf('cat(1, Vec{:, %d})', n);
    end
    Exp = sprintf(Exp, VecNames{:});
        
    idx = find(eval(Exp));
    S = S(idx);
%FILTER via lijst van veldnamen en hun respectievelijke waarden ...
elseif rem(length(varargin), 2) == 0 & iscellstr(varargin(1:2:end)), 
    %Gegevens herorganiseren ...
    [C, F] = destruct(S);
    
    FilterFields = varargin(1:2:end);
    FilterValues = varargin(2:2:end);
    
    if ~all(ismember(FilterFields, F)), error('One of the fieldnames to filter by doesn''t exist.'); end
    
    %Filter toepassen op structure-array ...
    NFields = length(FilterFields);
    [NRow, NCol] = size(C);
    
    idx = 1:NRow;
    for n = 1:NFields,
        rowidx = find(strcmp(F, FilterFields{n})); 
        
        switch class(FilterValues{n})
        case 'double',
            %Indien matrix van doubles opgegeven als waarde dan alle elementen weerhouden in de tabel die als waarde 
            %voor de overeenkomende kolomnaam een van de waarden hebben in de matrix ...
            D = cat(2, C{:, rowidx});
            idx = intersect(idx, find(any(repmat(D, length(FilterValues{n}), 1) == repmat(FilterValues{n}', 1, NRow), 1)));
        case 'char', idx = intersect(idx, find(strcmp(C(:, rowidx), FilterValues{n})));
        otherwise, error(sprintf('Filter for columns with value of type %s not implemented yet.', class(FilterValues{n}))); end    
    end
    
    S = S(idx);
else, error(sprintf('Invalid syntax: additional arguments should be names of fields to filter by, each field\nfollowed by its corresponding value, or a character array containing a conditional expression.')); end

%--------------------------------------------------locals-------------------------------------------------
function [FieldNames, Exp] = local_parse(Exp)
%Zoeken naar door dollar tekens omgeven veldnamen ...

DolSidx = find(Exp == '$'); 
if rem(length(DolSidx), 2) ~= 0, error('Invalid syntax in conditional expression: dollar signs should always match up.'); end
DolSidx = reshape(DolSidx, 2, length(DolSidx)/2)';

NFieldNames = size(DolSidx, 1); FieldNames = cell(1, NFieldNames);
for n = 1:NFieldNames, FieldNames{n} = Exp(DolSidx(n, 1)+1:DolSidx(n, 2)-1); end 

for n = 1:NFieldNames, Exp = strrep(Exp, ['$' FieldNames{n} '$'], '%s'); end