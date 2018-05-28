function String = ExportTable(TableObject)
%EXPORTTABLE  export a table to a character array that can be saved as a text-file, and
%             converted to a spreadsheet. (Fields of a record are TAB-delimited.)
%   String = EXPORTTABLE(TableObject)
%   Input parameter
%   TableObject : datatype created with OPENTABLE
%
%   Output parameter
%   String  : a character array with every row corresponding to a record, and fields of a
%             record separated with TABS.
%
%   See also OPENTABLE, WRITETABLE, ADDRECORD, GETRECORD, RMRECORD, FINDRECORD, SETTABLEDATA, GETTABLEDATA,
%            ISEMPTYTABLE, GETTABLEFIELD, GETKEYFIELD

String = '';

%Parameters nagaan ...
if nargin ~= 1, error('Wrong number of input arguments'); end
if ~CheckTableObject(TableObject), error('Argument should be table object'); end

%Exporteren ...
Data = GetTableData(TableObject);
if isempty(Data), return; end

String = cv2str(Table);



