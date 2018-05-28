function [DSNr, dsID, RecTime] = GetMadisonDSInfo(FileName, dsID)

%Parameters nagaan ..
if nargin ~= 2
    error('Wrong number of input arguments');
end
if ~ischar(FileName)
    error('First argument should be filename');
end

switch class(dsID)
    case 'double'
        DSNr = dsID; dsID = GetMadisondsID(FileName, DSNr);
    case 'char'
        DSNr = GetMadisonDSnr(FileName, dsID);
    otherwise
        error('Wrong input arguments.');
end

%Openen van Madison datafile in binaire mode ...
fid = fopen(FileName, 'r', 'ieee-le');
if fid == -1
    error('Couldn''t open datafile');
end

DirEntry = GetMadisonDirEntry(fid, DSNr);
DSHeader = GetMadisonDSHeader(fid, DirEntry.DataSetLocation);
RecTime = DSHeader.RecTime;

fclose(fid);
