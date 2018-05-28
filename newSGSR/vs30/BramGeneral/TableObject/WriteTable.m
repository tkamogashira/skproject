function WriteTable(TableObject)
%WRITETABLE  store table object on disk
%   WRITETABLE(TableObject)
%   Input parameter
%   TableObject : datatype created with OPENLIST 
%
%   The filename and path where the table object is stored should be specified when the table is created
%   with OPENTABLE.
%
%   See also OPENTABLE, ADDRECORD, GETRECORD, RMRECORD, FINDRECORD, SETTABLEDATA, GETTABLEDATA, ISEMPTYTABLE,
%            GETTABLEFIELD, GETKEYFIELD, EXPORTTABLE

%Parameters nagaan ...
if nargin < 1, error('Wrong number of input arguments'); end
    
if ~CheckTableObject(TableObject), error('First argument should be table object'); end

%Gegevens opslaan ...
Header = TableObject.Header;
Data   = TableObject.Data;

Path         = Header.Path;
FullFileName = Header.FullFileName;

Header = rmfield(Header, 'Path');
Header = rmfield(Header, 'FullFileName');

try save(fullfile(Path, FullFileName), 'Header', 'Data', '-mat');
catch error(['Couldn''t save ' fullfile(Path, FullFileName)]); end
