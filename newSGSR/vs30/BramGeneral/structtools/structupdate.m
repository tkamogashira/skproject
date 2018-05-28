function S = StructUpdate(S, FieldName, RowNr, NewValue)
%STRUCTUPDATE   change values of a structure-array.
%   S = STRUCTUPDATE(S, FieldName, RowNr, NewValue) changes the value in the 
%   structure-array S located in the column with name FieldName and at the 
%   specified row number. The value of this location is set to the specified
%   new value. Multiple row numbers of the same column can be changed at once
%   by supplying a vector.
%
%   See also STRUCTVIEW, STRUCTDISP, STRUCTSORT, STRUCTMERGE, STRUCTFIELD and
%   STRUCTPLOT.

%B. Van de Sande 25-04-2005

%------------------------------main program-----------------------------------
%Evaluate input arguments ...
if (nargin < 4), error('Wrong number of input arguments.'); end
if ~isstruct(S), error('First argument should be structure-array.'); end
if ~ischar(FieldName), error('Second argument should be character string with fieldname.'); end
if ~isnumeric(RowNr) | ~any(size(RowNr) == 1) | ~all(mod(RowNr, 1) == 0), error('Third argument should be scalar or vector of integers.'); end

%Actually change the structure-array ...
[Data, FieldNames] = destruct(S);
if ~ismember(FieldName, FieldNames), error(sprintf('''%s'' is not a valid fieldname for the supplied structure-array.', FieldName)); end
ColNr = find(ismember(FieldNames, FieldName));
N = length(S);
if (any(RowNr) <= 0) | (any(RowNr) > N), error('Invalid row number for supplied structure-array.'); end
[Data{RowNr, ColNr}] = deal(NewValue);
S = construct(Data, FieldNames);

%-----------------------------------------------------------------------------