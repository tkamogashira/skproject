function DataSetHeader = GetMadisonDSHeader(fid, DataSetLocation)
%Word Number (32-bit)    Contents
%--------------------    --------
%        1-2             Schema name (8 characters)
%        3               Data set size (blocks)
%        4-6             Animal ID (12 characters)
%        7-9             Data set ID (12 characters)
%        10-11           Date (DDMMM-YY) (8 characters)
%        12              Time in 10th of secs since midnight
%        13              Experiment type code (4 characters)

DataSetHeader = struct([]);

FileOffSet = 512 * (DataSetLocation-1);
fseek(fid, FileOffSet, 'bof');

SchemaName      = lower(deblank(char(freadVAXG(fid, 8, 'uchar')')));
DataSetSize     = freadVAXG(fid, 1, 'uint32');
AnimalID        = lower(deblank(char(freadVAXG(fid, 12, 'uchar')')));
DataSetID       = lower(deblank(char(freadVAXG(fid, 12, 'uchar')')));
Date            = deblank(char(freadVAXG(fid, 8, 'uchar')'));
Time            = freadVAXG(fid, 1, 'uint32');
ExpType         = lower(deblank(char(freadVAXG(fid, 4, 'uchar')')));

Date = TransFormMadisonDate(Date);

Hour = floor(Time/36000);
Min  = floor(rem(Time,36000)/600);
Sec  = rem(rem(Time,36000),600)/10;
RecTime = [Date(1:3), Hour, Min, Sec];

DataSetHeader = CollectInStruct(DataSetID, ExpType, RecTime, SchemaName, DataSetSize);

