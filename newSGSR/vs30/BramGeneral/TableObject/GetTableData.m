function Data = GetTableData(TableObject)
%GETTABLEDATA    give raw data in a table object as a structure-array
%   Data = GETTABLEDATA(TableObject)
%   Input parameters
%   TableObject  : datatype created with OPENTABLE
%
%   Output parameter
%   Data         : a structure array containing the records of a table
%
%   See also OPENTABLE, WRITETABLE, ADDRECORD, GETRECORD, RMRECORD, FINDRECORD, SETTABLEDATA, ISEMPTYTABLE,
%            GETTABLEFIELD, GETKEYFIELD, EXPORTTABLE

Data = struct([]);

%Parameters nagaan ...
if nargin ~= 1, error('Wrong number of input parameters'); end
if ~CheckTableObject(TableObject), error('First argument should be table object'); end

if TableObject.Header.NItems ~= 0, Data = TableObject.Data; end
