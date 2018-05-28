function OK = SPKinitFile(fname, initNdirBlocks)

% function SPKinitFile(fname, numDirBlocks);
% default numDirBlocks is 400 (good for 400x24=9600 sequences)

if nargin<2
    initNdirBlocks = 400;
end

ffname = [fname '.SPK'];
if exist(ffname, 'file')
    error([ffname ' is existing file']);
end

% initial header values
activeHeader = SPKcreateHeader(initNdirBlocks);
data_rec_type = 1; %dir block
fid = fopen(ffname, 'w', 'ieee-le');
for iblock = 1:initNdirBlocks
   % record-type identification
   fwriteVAXD(fid, data_rec_type-1, 'uint8');
   fwriteVAXD(fid, 0, 'uint8'); % alignment
   % header
   if iblock==1
       SPKwriteHeader(fid, activeHeader);
   end
   % the rest is zeros as yet
   IDFfillToNextBlock(fid);
end
OK = isequal(ftell(fid), initNdirBlocks*256);
fclose(fid);
