function Entry = readEDFDirEntry(fid, EntryNr)

%B. Van de Sande 29-07-2003

% Word Number (32-bit)    Contents
% --------------------    --------
%         1-2             Schema name (8 characters)
%         3               Data set size (in blocks)
%         4-6             DSID (12 characters)
%         7               Location of data set (block)
%         8               Experiment Type Code (4 chars)

FileOffSet = 64 + (EntryNr-1)*32; fseek(fid, FileOffSet, 'bof');

SchName = lower(deblank(char(freadVAXG(fid, 8, 'uchar')')));
DsSize  = freadVAXG(fid, 1, 'uint32');
DsID    = lower(deblank(char(freadVAXG(fid, 12, 'uchar')')));
DsLoc   = freadVAXG(fid, 1, 'uint32');
ExpType = lower(deblank(char(freadVAXG(fid, 4, 'uchar')')));

Entry = CollectInStruct(DsID, ExpType, SchName, DsLoc, DsSize);

