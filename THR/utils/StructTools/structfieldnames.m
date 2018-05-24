function FNames = structfieldnames(S)
%STRUCTFIELDNAMES   get fieldnames of a structure-array.
%   FNames = STRUCTFIELDNAMES(S) returns the fieldnames of the supplied
%   structure-array S as a cell-array of strings. For branched structures
%   fieldnames are returned with the dot as a fieldname separator.

%B. Van de Sande 02-08-2005

%Checking input arguments ...
if (nargin ~= 1), error('Wrong number of input arguments.'); end
if ~isstruct(S), error('First argument must be structure-array.'); end

%Returning fieldnames ...
if isempty(S), FNames = fieldnames(S);
else [dummy, FNames] = destruct(S(1)); end