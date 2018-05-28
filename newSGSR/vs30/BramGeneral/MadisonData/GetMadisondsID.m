function dsID = GetMadisondsID(FileName, SeqNr)

dsID = cell(0);

%Parameters nagaan ..
if nargin ~= 2
    error('Wrong number of input arguments');
end
if ~ischar(FileName)
    error('First argument should be filename');
end
if ~isnumeric(SeqNr)
    error('Second argument should be sequence number or vector of sequence numbers.');
end

%Openen van Madison datafile in binaire mode ...
fid = fopen(FileName, 'r', 'ieee-le');
if fid == -1
    error('Couldn''t open datafile');
end

%Directory structuur inlezen ...
DirHeader = GetMadisonDirHeader(fid);

if any(SeqNr > DirHeader.NEntries) || any(SeqNr <= 0)
    error('One of the sequence numbers doesn''t exist.');
end

NElem = numel(SeqNr);
for N = 1:NElem
    DirEntry = GetMadisonDirEntry(fid, SeqNr(N));
    dsID{N} = DirEntry.DataSetID;
end

fclose(fid);

dsID = reshape(dsID, size(SeqNr));
if NElem == 1
    dsID = dsID{1};
end
