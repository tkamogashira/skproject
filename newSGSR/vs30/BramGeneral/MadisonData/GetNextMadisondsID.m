function NextdsID = GetNextMadisondsID(FileName, dsID)

%Parameters nagaan ..
if nargin ~= 2
    error('Wrong number of input arguments');
end
if ~ischar(FileName)
    error('First argument should be filename');
end
if ~ischar(dsID)
    error('Second argument should be dataset ID');
end

%Openen van Madison datafile in binaire mode ...
%fid = fopen(FileName, 'r', 'vaxg'); if fid == -1, error('Couldn''t open datafile'); end
%
%Directory structuur inlezen ...
%DirHeader = GetMadisonDirHeader(fid);
%
%Zoeken naar DS ...
%Found = 0;
%for EntryNr = 1:DirHeader.NEntries
%    DirEntry = GetMadisonDirEntry(fid, EntryNr);
%    if strcmpi(dsID, DirEntry.DataSetID), Found = 1; break; end
%end
%
%NextEntry = EntryNr + 1;
%if Found & (NextEntry <= DirHeader.NEntries)
%    DirEntry = GetMadisonDirEntry(fid, NextEntry);
%    NextdsID = DirEntry.DataSetID;
%end
%
%fclose(fid);

DSNr = GetMadisonDSNr(FileName, dsID);
try
    NextdsID = GetMadisondsID(FileName, DSNr + 1);
catch
    NextdsID = '';
end
