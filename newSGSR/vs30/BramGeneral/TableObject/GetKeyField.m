function KeyField = GetKeyField(TableObject)
%GETKEYFIELD give the name of the field that serves as a key for a table object
%   KeyField = GETKEYTABLE(TableOject)
%   Input parameter
%   TableObject : datatype created with OPENTABLE
%
%   Output parameter
%   KeyField : name of the field that serves as a key for the table object specified. This field uniquely
%              idenitifies a record in the table.
%
%   See also OPENTABLE, WRITETABLE, ADDRECORD, GETRECORD, RMRECORD, FINDRECORD, SETTABLEDATA, GETTABLEDATA,
%            ISEMPTYTABLE, GETTABLEFIELD, EXPORTTABLE

KeyField = '';

%Parameters nagaan ...
if nargin ~= 1, error('Wrong number of input arguments'); end
if ~CheckTableObject(TableObject), error('First argument should be table object'); end

KeyField = TableObject.Header.KeyField;
