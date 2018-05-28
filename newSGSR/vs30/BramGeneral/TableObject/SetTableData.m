function TableObject = SetTableData(TableObject, Data)
%SETTABLEDATA    set all records of a table object to the data specified by a structure-array
%   TableObject = SETTABLEDATA(TableObject, Data)
%   Input parameters
%   TableObject : datatype created with OPENTABLE
%   Data        : structure-array with fields corresponding to the fields of a record in the table
%
%   CAUTION This operation removes all previously stored information.
%
%   See also OPENTABLE, WRITETABLE, ADDRECORD, GETRECORD, RMRECORD, FINDRECORD, GETTABLEDATA, ISEMPTYTABLE,
%            GETTABLEFIELD, GETKEYFIELD, EXPORTTABLE

%Parameters nagaan ...
if nargin ~= 2, error('Wrong number of input parameters'); end
if ~CheckTableObject(TableObject), error('First argument should be list object'); end
if ~isa(Data, 'struct') | (ndims(Data) ~= 2) | isempty(Data), error('Second argument should be a struct containing the records'); end
if ~isfield(Data(1), TableObject.Header.KeyField) | ~any(strcmp(class(getfield(Data(1), TableObject.Header.KeyField)) , {'char', 'double'})), error('Invalid structure'); end    

%List object aanpassen ...
NItems = length(Data);
KeyField = GetKeyField(TableObject);
Data = SortStruct(Data, KeyField);

TableObject.Data = Data;
TableObject.Header.NItems = NItems;
