function dirEntry = SPKcreateDirEntry(seqNum, startBlock, Nblock)

% function dirEntry = SPKcreateDirEntry(seqNum, startBlock, Nblock);
% seqNum==0 -> empty entry with all zeros

if nargin<1
    seqNum=0;
end

if seqNum==0
   startBlock =0;
   Nblock=0;
   sqt = 0;
   ig = 0;
else
   sqt = 1;
   ig = 1;
end

dirEntry.seq_num = seqNum;
dirEntry.start_block_num = startBlock;
dirEntry.num_blocks = Nblock;
dirEntry.seqs_this_num = sqt;
dirEntry.isgood = ig;
