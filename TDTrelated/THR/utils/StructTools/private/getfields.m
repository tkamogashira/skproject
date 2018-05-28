function S = getfields(S, FieldNames)
%GETFIELDS  get fieldnames from structure.
%   S = GETFIELDS(S, FieldNames) gets the fieldnames given as a cell-array of strings or as character string
%   in FieldNames from structure S, and return this as a structure with the same dimensions as S.

%B. Van de Sande 11-03-2004

if (nargin ~= 2), error('Wrong number of input arguments.'); end
if ~isstruct(S), error('First argument should be structure.'); end
if ~ischar(FieldNames) & ~iscellstr(FieldNames), error('Second argument should be cell-array of strings or character string of fieldnames.'); end

if ischar(FieldNames), FieldNames = cellstr(FieldNames); end
if ~all(ismember(FieldNames, fieldnames(S))), error('One of the fieldnames doesn''t exist in structure.'); end

Args = repmat({':'}, 1, ndims(S));

F = fieldnames(S);
C = struct2cell(S);

idx = find(ismember(F, FieldNames));

F = F(idx);
C = C(idx, Args{:});

S = cell2struct(C,F);