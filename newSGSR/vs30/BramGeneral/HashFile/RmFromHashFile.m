function RmFromHashFile(FileName, Key)
%RMFROMHASHFILE remove data from a hashfile used for storage. Entries cannot be deleted from a cache, they
%   are overwritten if the cache overflows.
%   RMFROMHASHFILE(FileName, Key)
%   Input parameters:
%     FileName : filename where data is stored (If no directory is supplied then the current directory 
%                is assumed. Default extension is .hash)
%     Key      : variable that uniquely identifies the data
% 
%   See also PUTINHASHFILE, GETFROMHASHFILE, DELETEHASHFILE, HASHFUNCTION

ID = 'HASHFILE';
Version = 1.0;

%Parameters nagaan ...
if nargin ~= 2, error('Wrong number of input parameters'); end

if ~ischar(FileName), error('First argument should be filename'); end
[Path, FileName, FileExt] = fileparts(FileName);
if isempty(Path), Path = pwd; end
if isempty(FileExt), FileExt = '.hash'; end
if isempty(FileName), error('First argument should be filename'); end
FullFileName = fullfile(Path, [FileName, FileExt]);

if isempty(Key), error('Key cannot be empty'); end

%Nagaan of bestand bestaat ... indien niet dan geen data opgeslagen voor die key ...
if ~exist(FullFileName, 'file'), return; end

%Bestand inladen ...
HashFile = load(FullFileName, '-mat');
if ~isfield(HashFile, 'Header') | ~isfield(HashFile.Header, 'ID') | ~isfield(HashFile.Header, 'Version') | ...
   ~isequal(HashFile.Header.ID, ID) | ~isequal(HashFile.Header.Version, Version)
    error(sprintf('%s is not a valid file', FileName));
end

UnPackStruct(HashFile);

%Key hashen naar nummer tussen 1 en NEntries ...
Index = feval(Header.HashFunc, Key, Header.NEntries);

switch Header.Mode
case 'STORAGE'
    DataFileName = [ FullFileName '__' int2str(Index) ];
    Short_DataFileName = [ FileName FileExt '__' int2str(Index) ];
    
    if ~isempty(Table{Index})
        if ~isequal(Short_DataFileName, Table{Index}), error('Internal inconsistency: Hash table function not reversible'); end
        
        ExtraHeaderItems = struct('Application', ID, 'ApplicationVersion', Version); 
        DataTable = OpenTable(DataFileName, ExtraHeaderItems, 'Key', 'Key', 'Data');
        RmRecord(DataTable, Key);
        if ~IsEmptyTable(DataTable)
            WriteTable(DataTable);
        else
            Table{Index} = [];
            delete(DataFileName);
        end
    end
otherwise, warning(sprintf('%s is not used for storage', FileName)); end    

%Hash table gegevens opslaan op schijf ...
save(FullFileName, 'Header', 'Table', 'Data', '-mat');