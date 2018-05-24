function S = descstruct(S, FieldName)
%DESCSTRUCT  descend structure
%   S = DESCSTRUCT(S, FieldName) descends into FieldName of structure-array S so that S will be a new
%   structure-array with the same dimensions, but one level down the fieldname-tree.

%B. Van de Sande 20-3-2003

if (nargin ~= 2) | ~isstruct(S) | ~ischar(FieldName), error('Wrong input parameters.'); end

idx = find(ismember(fieldnames(S), FieldName));
if isempty(idx), error(sprintf('%s doesn''t exist in %s.', FieldName, inputname(1))); end
C = struct2cell(S);
try S = cat(1, C{idx, :});
catch error(sprintf('%s-members are not unique.', FieldName)); end