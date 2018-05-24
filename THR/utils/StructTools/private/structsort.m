function S = structsort(S, FN, varargin)
%STRUCTSORT sort structure array
%   S = STRUCTSORT(S, FieldName) sorts structure S by fieldname FieldName. FieldName can be a cell-array
%   of fieldnames, and for branched structures fieldnames can be given by the form <SuperField1>.<SuperField2>.
%   ...<SubField>
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default values, use 'list' as only property.
%
%   See also STRUCTFILTER

%B. Van de Sande 07-07-2003, Niet verwarren met oude versie sortstruct.m

DefParam.mode = 'a'; %Ascending or descending ...

%Parameters nagaan ...
if nargin < 2, error('Wrong number of input arguments.'); end
if ~isstruct(S), error('First argument should be structure.'); end
if ~ischar(FN) & ~iscellstr(FN), error('Second argument should be fieldname to sort by.'); end
FN = cellstr(FN);

Param = checkproplist(DefParam, varargin{:});
if ~any(strncmpi(Param.mode, {'a', 'd'}, 1)), error('Invalid value for property mode.'); end

%Structure-array omzetten naar cell-array ...
[C, F] = destruct(S);
if ~all(ismember(FN, F)), error('One of the fieldnames doesn''t exist.'); end

%Sorteren ... Eerst sorteren volgens minst belangrijke veld, sorteerroutine houdt immers volgorde gelijk
%van de elementen die gelijk zijn.
NFields = length(FN);
for n = NFields:-1:1,
    idx = find(ismember(F, FN{n}));
    if isa(C{1, idx}, 'double'), [dummy, sidx] = sort(cat(2, C{:, idx}));
    else, [dummy, sidx] = sort(C(:, idx)); end
    S = S(sidx);
end

%Indien omgekeerde gesorteerd gevraagd werd ...
if strncmpi(Param.mode, 'd', 1), S = S(end:-1:1); end
