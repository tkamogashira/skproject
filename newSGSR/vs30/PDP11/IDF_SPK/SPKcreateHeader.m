function header = SPKcreateHeader(NdirBlocks, Nblocks, Nseq)

% function header = SPKcreateHeader(NdirBlocks, Nblocks, Nseq);
% if first arg is empty, an empty (inactive) header is returned

if nargin<1
    NdirBlocks = [];
end
if nargin<2
    Nblocks = NdirBlocks;
end
if nargin<3
    Nseq = 0;
end

if isempty(NdirBlocks) % create inactive header
   vs = 0;
   Nblocks = 0;
   Nseq = 0;
   NdirBlocks = 0;
else
   global SGSR;
   vs = SGSR.IDF_SPKversion;
end

% fill header struct
header.data_rec_kind = 1; % directory_record
header.version              =  vs;
header.blocks_used          =  Nblocks;
header.num_data_sets        =  Nseq;
header.num_directory_blocks =  NdirBlocks;
