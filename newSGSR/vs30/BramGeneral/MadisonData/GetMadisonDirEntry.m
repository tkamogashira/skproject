function Entry = GetMadisonDirEntry(fid, EntryNr)
% Word Number (32-bit)    Contents
% --------------------    --------
%         1-2             Schema name (8 characters)
%         3               Data set size (in blocks)
%         4-6             DSID (12 characters)
%         7               Location of data set (block)
%         8               Experiment Type Code (4 chars)

FileOffSet = 64 + (EntryNr-1)*32;
fseek(fid, FileOffSet, 'bof');

SchemaName          = lower(deblank(char(freadVAXG(fid, 8, 'uchar')')));
DataSetSize         = freadVAXG(fid, 1, 'uint32');
DataSetID           = lower(deblank(char(freadVAXG(fid, 12, 'uchar')')));
DataSetLocation     = freadVAXG(fid, 1, 'uint32');
ExpType             = lower(deblank(char(freadVAXG(fid, 4, 'uchar')')));

Entry = CollectInStruct(DataSetID, ExpType, DataSetLocation, DataSetSize, SchemaName);

