function Props = Struct2PropList(S, idx)
%STRUCT2PROPLIST convert struct to property/value list
%   Props = STRUCT2PROPLIST(S) converts the structure S to the cell-array
%   vector Props. The elements of Props are fieldname/fieldvalue pairs.
%   This cell array can then be used as a comma-separated list argument
%   for other functions.
%   Props = STRUCT2PROPLIST(S, idx) only converts fieldnames with specfied
%   indices.

%B. Van de Sande 30-04-2004

%Checking input arguments ...
if ~any(nargin == [1,2]), error('Wrong number of input arguments.'); end
if ~isstruct(S) | (length(S) ~= 1), error('First argument should be scalar structure.'); end

PropNames  = fieldnames(S); NProps = length(PropNames);
if (nargin == 1), idx = 1:NProps;
elseif ~all(ismember(idx, 1:NProps)), error('Incorrect indices.'); end
PropValues = struct2cell(S);
Props = vectorzip(PropNames, PropValues)';