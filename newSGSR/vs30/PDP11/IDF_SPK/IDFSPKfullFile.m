function TooFull = IDFSPKfullFile(fname)
% IDFSPKfullFile - test if IDF/SPK files are full
%  default name filename is current datafile

if nargin<1
   [ppp fname ] = fileparts(datafile);
   % fname = datafile;
end

% check for number of sequences present in IDF and SPK files
idfHeader = IDFheaderRead(fname);
spkHeader = SPKreadBlock(fname, 1);

idfNseq = idfHeader.num_seqs;
spkNseq = spkHeader.num_data_sets;

% find out at which block nr the last data end
if spkNseq>0
   idirBlock = 1+floor((spkNseq-1)/24);
   iblock = 1+rem(spkNseq-1,24);
   spkDir  = SPKreadBlock(fname, idirBlock);
   spkDir = spkDir.directory{iblock};
   Nxtblock = 1 + spkDir.start_block_num + spkDir.num_blocks;
else
   Nxtblock = 1 + spkHeader.num_directory_blocks;
end


TooFull = (idfNseq>=255) | (spkNseq>=255) | (Nxtblock>= 2^16-1);

