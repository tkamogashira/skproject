function S = rnfield(S, OldFieldName, NewFieldName)
%RNFIELD rename structure fields
%   S = RNFIELD(S, OldName, NewName) returns the structure S with the fieldname denoted by the string OldName
%   changed to NewName. OldName must exist in S.
%
%   If OldName and NewName are cell-arrays of equal length, each fieldname in OldName is changed to the
%   corresponding name in NewName.
%
% See also ROFIELD

%B. Van de Sande 16-06-2004

%Parameters nagaan ...
if nargin ~= 3, error('Wrong input arguments.'); end
if ~isstruct(S), error('First argument should be structure.'); end

FNames = fieldnames(S);
if ~all(ismember(OldFieldName, FNames)), 
    error('Second argument should be caharcter string or cell-array with fieldnames.');
end
if ~any(strcmpi(class(NewFieldName), {'char', 'cell'})) | length(cellstr(NewFieldName)) ~= length(cellstr(OldFieldName)),
    error('Third argument must be character string or cell-array of same length as second argument.');
end

OldFieldName = cellstr(OldFieldName);
NewFieldName = cellstr(NewFieldName);

%Veldnamen hernoemen ...
C = struct2cell(S);
for n = 1:length(OldFieldName), idx(n) = find(strcmp(FNames, OldFieldName{n})); end

FNames(idx) = NewFieldName;
S = cell2struct(C, FNames);