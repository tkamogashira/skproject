function S = StructReduce(S, FieldNames)
%STRUCTREDUCE   change values of a structure-array.
%   S = STRUCTREDUCE(S, FieldNames) reduces the number of columns of a
%   structure-array so that only the supplied cell-array of fieldnames 
%   remain.
%
%   See also STRUCTVIEW, STRUCTDISP, STRUCTSORT, STRUCTMERGE, STRUCTFIELD and
%   STRUCTPLOT.

%B. Van de Sande 25-04-2005

%------------------------------main program-----------------------------------
%Evaluate input arguments ...
if (nargin < 2), error('Wrong number of input arguments.'); end
if ~isstruct(S), error('First argument should be structure-array.'); end
if ~ischar(FieldNames) & ~iscellstr(FieldNames), error('Second argument should be character string or cell-array with fieldname(s).'); end
FieldNames = cellstr(FieldNames);

%Actually change the structure-array ...
[Data, FNames] = destruct(S);
if ~all(ismember(FieldNames, FNames)), error('Some fieldnames are not valid for the supplied structure-array.'); end
N = length(FieldNames); ColNrs = zeros(1, N);
for n = 1:N, ColNrs(n) = find(ismember(FNames, FieldNames{n})); end
S = construct(Data(:, ColNrs), FNames(ColNrs));

%-----------------------------------------------------------------------------