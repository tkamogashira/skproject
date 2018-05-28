function PutInHashFile(FileName, Key, ItemData, NEntries, HashFunc)
%PUTINHASHFILE store data in a hashfile
%   PUTINHASHFILE(FileName, Key, Data, {NEntries, HashFunc})
%   Input parameters:
%     FileName : filename where data is to be stored (If no directory is supplied then the current directory 
%                is assumed. Default extension is .hash)
%     Key      : variable that uniquely identifies the data
%     Data     : data to be stored
%     NEnties  : If NEntries is negative then the data is stored in one file with maximum number of 
%                data elements given by NEntries (CACHE-function). Otherwise data is stored over multiple 
%                files, with FileName containing the hash table. In this case NEntries gives the number of
%                entries in the hash table and there is no maximum number of entries (STORAGE-function).
%                This argument is mandatory if the hashfile is created, afterwards it can be omitted.
%     HashFunc : name of hashfunction to be used for this hashfile. This argument is optional and if not 
%                supplied a general hashfunction is used. The hashfunction should have two input arguments,
%                the first being the key to be transformed, the second the number of entries in the hash table.
%                It should give back the index in the hash table and should be located in the MATLAB path. 
%                Caution: the hashfunction associated with a hashfile cannot be changed after it has been created.  
% 
%   See also GETFROMHASHFILE, RMFROMHASHFILE, DELETEHASHFILE, HASHFUNCTION

ID = 'HASHFILE';
Version = 1.0;

%Parameters nagaan ...
if ~any(nargin == [3,4,5])
    error('Wrong number of input parameters'); 
end

if ~ischar(FileName)
    error('First argument should be filename'); 
end
[Path, FileName, FileExt] = fileparts(FileName);
if isempty(Path)
    Path = pwd; 
end
if isempty(FileExt), FileExt = '.hash'; end
if isempty(FileName), error('First argument should be filename'); end
FullFileName = fullfile(Path, [FileName, FileExt]);

if isempty(Key), error('Key cannot be empty'); end

if any(nargin == [4,5]),
    if ~isnumeric(NEntries) | (ndims(NEntries) ~= 2) | (length(NEntries) ~= 1) | (NEntries == 0)
        error('Number of entries should be scalar with maximum number of entries');
    end
    if ~isprime(abs(NEntries)), warning('Number of entries in a hash table should best be a prime number'); end
    
    if NEntries < 1, Mode = 'CACHE'; NEntries = abs(NEntries); 
    else Mode = 'STORAGE'; end    
else, NEntries = 0; end

if nargin == 5,
    if ~exist(HashFunc, 'file'), error('Hashfunction doesn''t exist'); end
else, HashFunc = 'HashFunction'; end

%Nagaan of bestand reeds bestaat, indien niet dan initialisatie ...
if ~exist(FullFileName, 'file')
    if (NEntries == 0), error('If hashfile is created, NEntries should be given'); end
    
    Header = CollectInStruct(ID, Version, Mode, NEntries, HashFunc);
    Table  = cell(NEntries, 1);
    Data   = cell(0);
else
    HashFile = load(FullFileName, '-mat');
    if ~isfield(HashFile, 'Header') | ~isfield(HashFile.Header, 'ID') | ~isfield(HashFile.Header, 'Version') | ...
       ~isequal(HashFile.Header.ID, ID) | ~isequal(HashFile.Header.Version, Version)
        error(sprintf('%s is not a valid file', FileName));
    end
    
    if ~strcmp(HashFile.Header.Mode, Mode), error(sprintf('Different mode for %s', FileName)); end
    
    if (NEntries ~= 0) & ~isequal(HashFile.Header.NEntries, NEntries),
        switch Mode
        case 'CACHE',     
            warning('Different maximum number of entries in hashfile'); 
            DeleteHashFile(FullFileName);
            PutInHashFile(FileName, Key, Data, NEntries, HashFunc);
            return;
        case 'STORAGE', error('Different number of entries in hashtable'); end    
    end
    
    if ~isequal(HashFile.Header.HashFunc, HashFunc)
        switch Mode
        case 'CACHE', 
            warning('Different hashfunction for this hashfile');
            DeleteHashFile(FullFileName);
            PutInHashFile(FileName, Key, Data, NEntries, HashFunc);
            return;
        case 'STORAGE', error('Different hashfunction for this hashfile'); end
    end    
    
    UnPackStruct(HashFile);
end    

%Key hashen naar nummer tussen 1 en NEntries ...
Index = feval(HashFunc, Key, NEntries);

%Mode nagaan ...
switch Mode
case 'CACHE'    
    if isempty(Table{Index}) %Lege entry, dus gewoon invoegen ...
        Table{Index} = Key;
        Data{Index}  = ItemData;
    elseif isequal(Table{Index}, Key) %Updaten van entry ...
        Data{Index}  = ItemData;
    else %Aanvaring met reeds aanwezige entry ... oplossen via kwadratische toetsing van de tabel ...
        MaxToetsing = floor((NEntries + 1)/2);
        nToets = 1; Vol = 1;
        while nToets <= MaxToetsing
            ToetsIndex = mod(Index + nToets.^2, NEntries) + 1;
            if isempty(Table{ToetsIndex}) %Lege entry, dus gewoon invoegen ...
                Table{ToetsIndex} = Key;
                Data{ToetsIndex}  = ItemData;
                Vol = 0; break;
            elseif isequal(Table{ToetsIndex}, Key) %Updaten van entry ...
                Data{ToetsIndex}  = ItemData;
                Vol = 0; break;
            end
            nToets = nToets + 1;
        end
        %Indien vol dan gewoon entry plaatsen thv oorspronkelijke index ...
        if Vol,
            Table{Index} = Key;
            Data{Index}  = ItemData;
        end
    end
case 'STORAGE'
    DataFileName = [ FullFileName '__' int2str(Index) ];
    Short_DataFileName = [ FileName FileExt '__' int2str(Index) ];
        
    if isempty(Table{Index}), Table{Index} = Short_DataFileName; 
    elseif ~isequal(Short_DataFileName, Table{Index}), error('Internal inconsistency: Hash table function not reversible'); end
    
    ExtraHeaderItems = struct('Application', ID, 'ApplicationVersion', Version); 
    DataTable = OpenTable(DataFileName, ExtraHeaderItems, 'Key', 'Key', 'Data');
    DataTable = AddRecord(DataTable, 'Key', Key, 'Data', ItemData);
    WriteTable(DataTable);
end

%Hash table gegevens opslaan op schijf ...
save(FullFileName, 'Header', 'Table', 'Data', '-mat');