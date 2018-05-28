function DsHeader = readEDFDsHeader(fid, DsLoc)

%B. Van de Sande 29-07-2003

%Word Number (32-bit)    Contents
%--------------------    --------
%        1-2             Schema name (8 characters)
%        3               Data set size (blocks)
%        4-6             Animal ID (12 characters)
%        7-9             Data set ID (12 characters)
%        10-11           Date (DDMMM-YY) (8 characters)
%        12              Time in 10th of secs since midnight
%        13              Experiment type code (4 characters)

FileOffSet = 512 * (DsLoc-1); fseek(fid, FileOffSet, 'bof');

SchName  = lower(deblank(char(freadVAXG(fid, 8, 'uchar')')));
DsSize   = freadVAXG(fid, 1, 'uint32');
AnimalID = lower(deblank(char(freadVAXG(fid, 12, 'uchar')')));
DsID     = lower(deblank(char(freadVAXG(fid, 12, 'uchar')')));
Date     = deblank(char(freadVAXG(fid, 8, 'uchar')'));
Time     = freadVAXG(fid, 1, 'uint32');
ExpType  = lower(deblank(char(freadVAXG(fid, 4, 'uchar')')));

RecTime  = EDFDate2Vec(Date, Time);

DsHeader = CollectInStruct(DsID, ExpType, RecTime, SchName, DsSize);

