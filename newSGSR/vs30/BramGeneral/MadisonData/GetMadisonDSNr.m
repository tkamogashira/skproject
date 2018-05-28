function DSNr = GetMadisonDSNr(FileName, dsID)

DSNr = [];

%Parameters nagaan ..
if nargin ~= 2
    error('Wrong number of input arguments');
end
if ~ischar(FileName)
    error('First argument should be filename');
end
if ~ischar(dsID) && ~iscellstr(dsID)
    error('Second argument should be dataset ID or cell-array of dsIDs');
end

if ~iscellstr(dsID)
    dsID = { dsID };
end

%Openen van Madison datafile in binaire mode ...
fid = fopen(FileName, 'r', 'ieee-le');
if fid == -1
    error('Couldn''t open datafile');
end

%Directory structuur inlezen ...
DirHeader = GetMadisonDirHeader(fid);

NElem = length(dsID);

for N = 1:NElem
    %Search for DS ...
    Found = 0;
    for EntryNr = 1:DirHeader.NEntries
        DirEntry = GetMadisonDirEntry(fid, EntryNr);
        if strcmpi(dsID{N}, DirEntry.DataSetID)
            Found = 1;
            break;
        end
    end
    
    if Found
        DSNr = [DSNr, EntryNr]; 
    else
        DSNr = [DSNr, 0];
    end
end
fclose(fid);
