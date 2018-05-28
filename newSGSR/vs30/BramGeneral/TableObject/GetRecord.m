function Record = GetRecord(TableObject, TargetValue)
%GETRECORD   get a record from a table
%   Record = GETRECORD(TableObject, TargetValue)
%   Input parameters
%   TableObject : datatype created with OPENTABLE
%   TargetValue : value of keyfield
%   Every record of a table object can be uniquely identified by the value of its keyfield.   
%
%   Output parameter
%   Record      : structure containing the data for the record
%
%   See also OPENTABLE, WRITETABLE, ADDRECORD, RMRECORD, FINDRECORD, SETTABLEDATA, GETTABLEDATA, ISEMPTYTABLE,
%            GETTABLEFIELD, GETKEYFIELD, EXPORTTABLE

Record = struct([]);

%Parameters nagaan ...
if nargin ~= 2, error('Wrong number of input arguments'); end
if ~CheckTableObject(TableObject), error('First argument should be table object'); end
if ~isnumeric(TargetValue) & ~ischar(TargetValue) & ~isstruct(TargetValue), error('Value of fieldname to search by should be a double, a character string or a struct'); end

Index = FindRecord(TableObject, TargetValue);
if Index == 0, return; end

Record = TableObject.Data(Index);