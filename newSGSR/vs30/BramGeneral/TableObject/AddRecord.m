function TableObject = AddRecord(TableObject, varargin)
%ADDRECORD   add a record to a table
%   TableObject = ADDRECORD(TableObject, FieldName, FieldValue, ...)
%   Input parameters
%   TableObject : datatype created with OPENTABLE
%   Comma separated list of fieldnames and fieldvalues for the record to be added. All the
%   fields of a record should be specified and the order of fields should correspond to the one 
%   that was given when the table object was created.
%
%   See also OPENTABLE, WRITETABLE, GETRECORD, RMRECORD, FINDRECORD, SETTABLEDATA, GETTABLEDATA, ISEMPTYTABLE,
%            GETTABLEFIELD, GETKEYFIELD, EXPORTTABLE

%Parameters nagaan ...
if nargin < 1, error('Wrong number of input arguments'); end

if ~CheckTableObject(TableObject), error('First argument should be table object'); end

if isempty(varargin), error('Data for record to be added should be given'); end
Record = createstruct(varargin{:}); if isempty(Record), error('Data for record to be added should be given as fieldname/value list'); end
if ~compfields(TableObject.Data(1), Record), error('Data for record is not compatible'); end 

%TargetValue opzoeken ...
Data     = TableObject.Data;
KeyField = TableObject.Header.KeyField;

TargetValue = getfield(Record, KeyField);
if ~isnumeric(TargetValue) & ~ischar(TargetValue) & ~isstruct(TargetValue), error('Value of fieldname to search by should be a double, a character string or a struct'); end

%Extra Item toevoegen op juiste plaats in ordening ...
if TableObject.Header.NItems ~= 0
    [Found, Index] = binsrchstruct(Data, KeyField, TargetValue);
    if Found %Als Item reeds aanwezig dan updaten van informatie ...
        Data(Index) = Record;
    else %Anders Item tussenvoegen ...
        Data = add2struct(Data, Record, Index+1); 
    end    
else, Data = Record; Found = 0; end

TableObject.Data = Data;
if ~Found, TableObject.Header.NItems = TableObject.Header.NItems + 1; end
