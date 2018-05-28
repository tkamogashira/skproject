function Index = FindRecord(TableObject, TargetValue)
%FINDRECORD   give index of record in a table
%   Index = FINDRECORD(TableObject, TargetValue)
%   Input parameters
%   TableObject : datatype created with OPENTABLE
%   TargetValue : value of keyfield
%   Every record of a table object can be uniquely identified by the value of its keyfield.   
%
%   Output parameter
%   Index   : index of the record in the table. This information is useful only if the raw data in the table
%             is retrieved with GETTABLEDATA.
%
%   See also OPENTABLE, WRITETABLE, ADDRECORD, GETRECORD, RMRECORD, SETTABLEDATA, GETTABLEDATA, ISEMPTYTABLE,
%            GETTABLEFIELD, GETKEYFIELD, EXPORTTABLE

Index   = [];

%Parameters nagaan ...
if nargin ~= 2, error('Wrong number of input arguments'); end
if ~CheckTableObject(TableObject), error('Argument should be table object'); end
if ~isnumeric(TargetValue) & ~ischar(TargetValue) & ~isstruct(TargetValue), error('Value of fieldname to search by should be a double, a character string or a struct'); end

%Zoeken via binary search op gesorteerde lijst ...
if TableObject.Header.NItems ~= 0
    [Found, Index] = binsrchstruct(TableObject.Data, TableObject.Header.KeyField, TargetValue);
else
    Found = 0;
end

if ~Found, Index = 0; end
