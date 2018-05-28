function TableObject = RmRecord(TableObject, TargetValue)
%RMRECORD   remove a record from a table
%   TableObject = RMRECORD(TableObject, TargetValue)
%   Input parameters
%   TableObject : datatype created with OPENTABLE
%   TargetValue : value of keyfield
%   Every record of a table object can be uniquely identified by the value of its keyfield. 
%
%   See also OPENTABLE, WRITETABLE, ADDRECORD, GETRECORD, FINDRECORD, SETTABLEDATA, GETTABLEDATA, ISEMPTYTABLE,
%            GETTABLEFIELD, GETKEYFIELD, EXPORTTABLE

%Parameters nagaan ...
if nargin ~= 2, error('Wrong number of input arguments'); end
if ~CheckTableObject(TableObject), error('First argument should be table object'); end
if ~isnumeric(TargetValue) & ~ischar(TargetValue) & ~isstruct(TargetValue), error('Value of fieldname to search by should be a double, a character string or a struct'); end

Index = FindRecord(TableObject, TargetValue);
if Index == 0, return; end

TableObject.Data(Index)   = [];
TableObject.Header.NItems = TableObject.Header.NItems - 1;
