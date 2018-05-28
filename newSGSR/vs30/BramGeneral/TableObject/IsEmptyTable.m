function boolean = IsEmptyTable(TableObject)
%ISEMPTYTABLE    check if table object is empty
%   boolean = ISEMPTYTABLE(TableObject)
%   Input parameter
%   TableObject : datatype created with OPENTABLE 
%
%   Output parameter
%   boolean    : 0 if list object isn't empty, 1 if listobject is empty.
%
%   See also OPENTABLE, WRITETABLE, ADDRECORD, GETRECORD, RMRECORD, FINDRECORD, SETTABLEDATA, GETTABLEDATA,
%            GETTABLEFIELD, GETKEYFIELD, EXPORTTABLE

boolean = logical(0);

%Parameters nagaan ...
if nargin ~= 1, error('Wrong number of input arguments'); end
if ~CheckTableObject(TableObject), error('First argument should be table object'); end

boolean = (TableObject.Header.NItems == 0);