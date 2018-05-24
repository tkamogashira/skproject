function S = lowerfields(S)
%LOWERFIELDS    change fieldnames in structure to lowercase
%   S = LOWERFIELDS(S) changes all fieldnames in structure S to lowercase.

%B. Van de Sande 19-3-2003

if (nargin ~= 1) | ~isstruct(S), error('Only argument should be structure'); end

FNames = lower(fieldnames(S));
C = struct2cell(S);

try S = cell2struct(C, FNames);
catch error('Some fieldnames only differ in case.'); end    
