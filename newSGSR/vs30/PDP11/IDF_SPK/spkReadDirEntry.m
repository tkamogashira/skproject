function dir = spkReadDirEntry(fid, N)

% function dir = spkReadDirEntry(fid); - read directory entries
if nargin<2
    N = 1;
end

allUs = freadVAXD(fid, N*5, 'uint16');

dir = cell(1,N);
template.seq_num = 0;
template.start_block_num = 0;
template.num_blocks = 0;
template.seqs_this_num = 0;
template.isgood = 0;

for ii=1:N
   offset = (ii-1)*5;
   dir{ii} = template;
   dir{ii}.seq_num = allUs(offset+1);
   dir{ii}.start_block_num = allUs(offset+2);
   dir{ii}.num_blocks = allUs(offset+3);
   dir{ii}.seqs_this_num = allUs(offset+4);
   dir{ii}.isgood = allUs(offset+5);
end

if N==1
    dir = dir{1};
end

%dir.seq_num = freadVAXD(fid, 1, 'uint16');
%dir.start_block_num = freadVAXD(fid, 1, 'uint16');
%dir.num_blocks = freadVAXD(fid, 1, 'uint16');
%dir.seqs_this_num = freadVAXD(fid, 1, 'uint16');
%dir.isgood = freadVAXD(fid, 1, 'uint16');
