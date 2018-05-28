function spkWriteDirEntry(fname, iseq, dir)

% function spkWriteDirEntry(fname, iseq, dir);
% write single directory_entry
% fname is filename without extension .SPK

% first compute in which block the entry should be placed
dirOffset = 12;   % bytes due to header info
dirSize = 10;     % bytes occupied by dir entry
iEntry = 1+rem(iseq-1,24);
iBlock = 1+round((iseq-iEntry)/24);
totOffset = (iBlock-1)*256 + (iEntry-1)*dirSize + dirOffset;

% now check if the record is a directory record
ffname = [fname '.SPK'];
if ~exist(ffname,'file')
    error(['cannot find file ' ffname]);
end
fid = fopen(ffname, 'r', 'ieee-le');
if fseek(fid, totOffset, 'bof')
    error(ferror(fid));
end
fseek(fid, (iBlock-1)*256, 'bof');
recType = freadVAXD(fid, 1, 'uint8');
fclose(fid);

if ~isequal(recType,0)
    error('record is not a directory record');
end

% now open for writing and write
fid = fopen(ffname, 'r+', 'ieee-le');
if fseek(fid, totOffset, 'bof')
    error(ferror(fid));
end
fwriteVAXD(fid, dir.seq_num, 'uint16');
fwriteVAXD(fid, dir.start_block_num, 'uint16');
fwriteVAXD(fid, dir.num_blocks, 'uint16');
fwriteVAXD(fid, dir.seqs_this_num, 'uint16');
fwriteVAXD(fid, dir.isgood, 'uint8');
fwriteVAXD(fid, 0, 'uint8'); % alignment
newPos = ftell(fid);
fclose(fid);
