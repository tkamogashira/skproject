function spkAddSeqToFile(fname, spkSeq)

% function OK = spkAddSeqToFile(fname, spkSeq);
ffname = [fname '.SPK'];
if ~exist(ffname, 'file')
   warning(['file ' ffname ' does not exist - I will create it']);
   SPKinitFile(fname);
end

BlockSize = 256;
spk = SPKread(fname);

NdirEntries = spk.header.num_directory_blocks*24;
Nseqs = spk.header.num_data_sets;
Nblocks = spk.header.blocks_used;

if Nseqs==NdirEntries % no dir empty entry available
   SPKinsertDirRec(fname, 6); % insert 6 new dir blocks
   spk = spkread(fname);
end

iSeq = Nseqs+1;
% before we can write the blocks, we have to figure out how many 
% blocks we need, and were they are going to be in the SPK file
Nsubseq = length(spkSeq.subseqInfo);
Nrep = size(spkSeq.spikeCount,2);
Nspikes = sum(sum(spkSeq.spikeCount));
% constants from dattyp.ph
stim_info_len = 10;
arr_time_len = 63;
rep_info_len = 42;
% block locations and numbers
SeqInfoBlock = Nblocks+1; % first block to be appended
firstStimInfoBlock = SeqInfoBlock+1;
NstimInfoBlocks = 1+ floor(1e-8+(Nsubseq-1)/stim_info_len);
firstRepInfoBlock = firstStimInfoBlock + NstimInfoBlocks;
NrepInfoBlocks = 1+ floor(1e-8+(Nsubseq*Nrep-1)/rep_info_len);
firstDataBlock = firstRepInfoBlock + NrepInfoBlocks;
NdataBlocks = 1+ floor(1e-8+(Nspikes-1)/arr_time_len);
totalNblocks = 1 + NstimInfoBlocks + NrepInfoBlocks + NdataBlocks;
% spike counts per rep determine location of spike times.
% The location is here expressed as offset numbering from start,
% i.e., not bothering yet about distribution of these data over 
% blocks, etc.
sc = spkSeq.spikeCount.'; % transpose to get correct order, viz., ...
% ...running through all reps of a subseq and then jump to next subseq
SpikeOffset = [0 cumsum(sc(:)).'];% the zero is offset of 1st spiketime

% store this location info in the dir_entry field of spkSeq
% this field is thereby completely renewed (but not yet written
% to file)
spkSeq.dir_entry = [];
spkSeq.dir_entry.seq_num = iSeq;
spkSeq.dir_entry.start_block_num = SeqInfoBlock;
spkSeq.dir_entry.num_blocks = totalNblocks; 
spkSeq.dir_entry.seqs_this_num = 1; 
spkSeq.dir_entry.isgood = 1; 

% open the SPK for appending the blocks; dir entry will
% be updated after all blocks have been appended
% Note: in fact, "append" is not the word - a trailing zero-valued
% block (due to PDP11 size conventions) must be overwritten.
fid = fopen(ffname,'r+', 'ieee-le'); % append mode
if fseek(fid, BlockSize*Nblocks, 'bof')
   mess = ferror(fid);
   fclose(fid);
   error(mess);
end
% 1. update & write the seqInfo block
spkSeq.seqInfo.stim_info.seqnum = iSeq;
spkSeq.seqInfo.num_stim_info_recs = NstimInfoBlocks;
spkSeq.seqInfo.num_rep_info_recs = NrepInfoBlocks;
SPKwriteSeqInfo(fid, spkSeq.seqInfo); 
% 2. fill the stimInfo block(s)
offset = 0;
for iblock=1:NstimInfoBlocks
   SPKwriteStimInfo(fid, spkSeq.subseqInfo, offset);
   offset = offset + stim_info_len;
end
% 3. fill and write the rep info block(s)
%   first initialize repblock cell array
repBlock = cell(1, NrepInfoBlocks); % cell array of blocks
for iblock=1:NrepInfoBlocks % each single block is again a cell array
   repBlock{iblock} = cell(1, rep_info_len);
end
%   next visit all reps of all subseqs and store their spike-time locs
for iSubseq=1:Nsubseq
   for iRep=1:Nrep % iRep is rep *within* given subseq
      % count the reps over all subseqs
      iCount = (iSubseq-1)*Nrep + iRep; 
      iEntry = 1 + rem(iCount-1, rep_info_len); % entry within repblock
      iblock = 1 + round((iCount-iEntry)/rep_info_len); % block number
      repBlock{iblock}{iEntry}.loc = SpikeLoc(SpikeOffset(iCount));
      repBlock{iblock}{iEntry}.spkcount = ...
         spkSeq.spikeCount(iSubseq, iRep);
   end
end
%   now write these rep blocks to file
for iblock=1:NrepInfoBlocks
   SPKwriteRepInfo(fid, repBlock{iblock});
end

% 4. write the spike times
% spike times are stored in cell matrix the rows and columns of
% which specify iSubseq and iRep (within the subseq), resp.
% Storage in SPK file does not respect this structure, the
% spikes just run through all subseqs and, within the subseq,
% through all reps. The structure that is present in the data 
% storage is governed by the damned block structure of PDP files.

% scale factor depends on UET setting
tdecade = spkSeq.seqInfo.uet_info.tdecade;
tmult = spkSeq.seqInfo.uet_info.tmult;
scaleFactor = SPKscaleFactor(tmult, tdecade);
% put all spike times in a long array in the right order (see above)
spikeData = zeros(1, Nspikes);
offset = 0;
for iSubseq=1:Nsubseq
   for iRep=1:Nrep
      n = spkSeq.spikeCount(iSubseq, iRep);
      spikeData(offset+(1:n)) = ...
         scaleFactor * spkSeq.spikeTime{iSubseq, iRep};
	   offset = offset+n;
   end
end
% write to file
offset = 0;
for iblock=1:NdataBlocks
   SPKwriteDataArray(fid, spikeData, offset);
   offset = offset + arr_time_len;
end
fclose(fid);

% 5. update the directory entry and the header
SPKwriteDirEntry(fname, iSeq, spkSeq.dir_entry);
spk.header.num_data_sets = spk.header.num_data_sets + 1;
spk.header.blocks_used = spk.header.blocks_used + totalNblocks;
fid=fopen(ffname, 'r+', 'ieee-le');
SPKwriteHeader(fid, spk.header);
fclose(fid);
% 6. append empty block if number of blocks is uneven
fid=fopen(ffname, 'a', 'ieee-le');
fseek(fid,0,'eof');
nbytes = ftell(fid);
if rem(nbytes, 512)
    fwriteVAXD(fid,zeros(1,256),'uint8');
end
fclose(fid);


% ---locals-------
function loc = SpikeLoc(offset)
arr_time_len = 63;
loc.entry = 1+rem(offset, arr_time_len);
loc.recnum = 1 + round((offset+1-loc.entry)/arr_time_len);

% Seq info block
% fwrite(fid, [1 0], 'uint8');
% IDFfillToNextBlock(fid);
