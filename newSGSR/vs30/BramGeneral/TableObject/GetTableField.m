function Data = GetTableField(TableObject, FieldName)
%GETTABLEFIELD   give the value of a field for all records in a table object
%   Input parameter
%   TableObject : datatype created with OPENTABLE 
%   FieldName  : name of the field to be retrieved (can be more than one reference level deep)
%
%   Output parameter
%   Data    : value of all records in the table as a cell-array
%
%   See also OPENTABLE, WRITETABLE, ADDRECORD, GETRECORD, RMRECORD, FINDRECORD, SETTABLEDATA, GETTABLEDATA,
%            ISEMPTYTABLE, GETKEYFIELD, EXPORTTABLE

Data = cell(0);

%Parameters nagaan ...
if nargin ~= 2, error('Wrong number of input arguments'); end
if ~CheckTableObject(TableObject), error('First argument should be table object'); end
if ~ischar(FieldName), error('Second argument should be name of field to retrieve'); end

%Veld ophalen ...
FieldNames = Words2Cell(FieldName, '.');
NItems     = TableObject.Header.NItems;

if NItems == 0, return; end

try, Data{1} = getfield(TableObject.Data, {1}, FieldNames{:});
catch, error('Second argument should be name of field to retrieve'); end    

for ItemNr = 2:NItems
   Data{ItemNr} = getfield(TableObject.Data, {ItemNr}, FieldNames{:}); 
end
