function ItemData = GetFromHashFile(FileName, Key)
%GETFROMHASHFILE retrieve data from a hashfile
%   Data = GETFROMHASHFILE(FileName, Key)
%   Input parameters:
%     FileName : filename where data is stored (If no directory is supplied then the current directory 
%                is assumed. Default extension is .hash)
%     Key      : variable that uniquely identifies the data
%
%   Output parameter:
%     Data     : data stored in hashfile
% 
%   See also PUTINHASHFILE, RMFROMHASHFILE, DELETEHASHFILE, HASHFUNCTION

ID = 'HASHFILE';
Version = 1.0;

ItemData = [];

%Parameters nagaan ...
if nargin ~= 2
    error('Wrong number of input parameters'); 
end
if ~ischar(FileName)
    error('First argument should be filename'); 
end

[Path, FileName, FileExt] = fileparts(FileName);
if isempty(Path)
    Path = pwd; 
end
if isempty(FileExt)
    FileExt = '.hash'; 
end
if isempty(FileName)
    error('First argument should be filename'); 
end
FullFileName = fullfile(Path, [FileName, FileExt]);

if isempty(Key)
    error('Key cannot be empty'); 
end

%Nagaan of bestand bestaat ... indien niet dan geen data opgeslagen voor die key ...
if ~exist(FullFileName, 'file')
    return; 
end

%Bestand inladen ...
HashFile = load(FullFileName, '-mat');
if ~isfield(HashFile, 'Header') | ~isfield(HashFile.Header, 'ID') | ~isfield(HashFile.Header, 'Version') | ...
   ~isequal(HashFile.Header.ID, ID) | ~isequal(HashFile.Header.Version, Version)
    error([fileName 'is not a valid file']);
end

Header = HashFile.Header;
Table = HashFile.Table;
Data = HashFile.Data;

%Key hashen naar nummer tussen 1 en NEntries ...
Index = feval(Header.HashFunc, Key, Header.NEntries);

switch Header.Mode
case 'CACHE'    
    if isempty(Table{Index})
    elseif isequal(Table{Index}, Key)
        ItemData = Data{Index};
    else %Aanvaring ... oplossen via kwadratische toetsing van de tabel ...
        MaxToetsing = floor((Header.NEntries + 1)/2);
        nToets = 1;
        while nToets <= MaxToetsing
            ToetsIndex = mod(Index + nToets.^2, Header.NEntries) + 1;
            if isempty(Table{ToetsIndex})
                break;
            elseif isequal(Table{ToetsIndex}, Key)
                ItemData = Data{ToetsIndex}; 
                break;
            end
            nToets = nToets + 1;
        end
    end
case 'STORAGE'
    DataFileName = [ FullFileName '__' int2str(Index) ];
    Short_DataFileName = [ FileName FileExt '__' int2str(Index) ];
    
    if ~isempty(Table{Index})
        if ~isequal(Short_DataFileName, Table{Index})
            error('Internal inconsistency: Hash table function not reversible'); 
        end
        
        ExtraHeaderItems = struct('Application', ID, 'ApplicationVersion', Version); 
        DataTable = OpenTable(DataFileName, ExtraHeaderItems, 'Key', 'Key', 'Data');
        Record = GetRecord(DataTable, Key);
        if ~isempty(Record)
            ItemData = Record.Data; 
        end
    end
end    