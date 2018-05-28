function rec = SPKreadBlock(fid,BlockNum, BlockSize)

% function rec = SPKreadBlock(fid,BlockNum, BlockSize);
% reads the BlockNum-th block (counted from 1) of
% SPK file opened with    fid=fopen(fname, 'r', 'vaxd')
% if record does not exist, record with type "-1" is returned
% if fid is string, a file with that name is opened

CloseFile = 0;
if ischar(fid)
   fid = fullFileName(fid, datadir, 'SPK', 'SPK file');
   fid = fopen(fid, 'r', 'ieee-le');
   CloseFile = 1;
end

if nargin<2
    error('insufficient input args');
end
if nargin<3
    BlockSize=256;
end

if fseek(fid, BlockNum*256-1,'bof')
   rec.data_rec_kind = -1;
   return
end

if fseek(fid, (BlockNum-1)*256,'bof')
    error(ferror(fid));
end

readFun = {'spkReadDirInfo' 'SPKreadSeqInfo' ...
      'spkReadStimInfo' 'spkReadRepInfo' 'spkReadDataArray'};

[rc count] = freadVAXD(fid,1,'uint8');
freadVAXD(fid,1,'uint8');
if ~count
    N=ii-1;
    return
end

evalstr = ['rec = ' readFun{rc+1} '(fid);'];
eval(evalstr);

if CloseFile
    fclose(fid);
end
