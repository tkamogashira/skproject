function [spkSeq, Nsubseq, Nreps] = SPKget(spk, iseq)

%-- 06/02/10 peterbr -> R2009 does not support vaxd anymore --%
% if( isunix )
 	form='ieee-le';
% else
% 	form='ieee-be';
% end

% function spkSeq = SPKget(spk, iseq);
if isnumeric(spk) % interpret as index of test set
   spk = PDPtestsetName(spk);
end
if ischar(spk) % filename rather than spk struct
   spk = SPKread(spk);
end

iseq = abs(iseq);
if isinf(iseq)
    iseq = spk.header.num_data_sets;
end
if (iseq<1) || (iseq>spk.header.num_data_sets)
   error(['sequence ' num2str(iseq) ' not present in spk']);
end
% extract info from directory entry (present in spk)
spkSeq.dir_entry = spk.dir{iseq};
totNumBlocks = spk.dir{iseq}.num_blocks;
seqInfoBlock = spk.dir{iseq}.start_block_num;

% the rest of the info is not in spk - it has to be read ...
% ...from the SPK file
fid=fopen(spk.filename,'r',form);

spkSeq.seqInfo = SPKreadBlock(fid, seqInfoBlock);

startSubseqInfo = seqInfoBlock+1; % there's just one  seq_info record
endSubseqInfo = startSubseqInfo-1+spkSeq.seqInfo.num_stim_info_recs;

Nsubseq = spkSeq.seqInfo.num_series1 * spkSeq.seqInfo.num_series2;
spkSeq.subseqInfo = cell(1,Nsubseq);
isubseq = 0;
for iblock=startSubseqInfo:endSubseqInfo
   rec = SPKreadBlock(fid, iblock);
   for irec = 1:10
      isubseq = isubseq + 1;
      spkSeq.subseqInfo{isubseq} = rec.stimrec{irec};
      if isubseq==Nsubseq
          break
      end
   end
end

startRepInfo = endSubseqInfo+1;
endRepInfo = startRepInfo - 1 + spkSeq.seqInfo.num_rep_info_recs;

Nreps = spkSeq.seqInfo.stim_info.repcount;
RepLoc = cell(Nsubseq,Nreps);
spkSeq.spikeCount = zeros(Nsubseq,Nreps);
isubseq=1;
irep = 0;
for iblock=startRepInfo:endRepInfo
   rec = SPKreadBlock(fid, iblock);
   for irec = 1:42
      irep = irep + 1;
      if irep>Nreps
         irep=1;
         isubseq=isubseq+1;
      end
      RepLoc{isubseq, irep} = rec.reprec{irec}.loc;
      %REPLOC = rec.reprec{irec}.loc
      spkSeq.spikeCount(isubseq, irep) = rec.reprec{irec}.spkcount;
      if (irep==Nreps) && (isubseq==Nsubseq)
          break
      end
   end
end

startSpikeInfo = endRepInfo+1;
endSpikeInfo = seqInfoBlock-1+totNumBlocks;
NspikeBlocks = endSpikeInfo - startSpikeInfo + 1;

% DEBUG
% spkSeq.startSpikeInfo = startSpikeInfo;
% spkSeq.endSpikeInfo = endSpikeInfo;

% from sclclc.pas
tdecade = spkSeq.seqInfo.uet_info.tdecade;
tmult = spkSeq.seqInfo.uet_info.tmult;
scaleFactor = SPKscaleFactor(tmult, tdecade);
% first concatenate all spike arrival times
spikeTimes = zeros(1, NspikeBlocks*63);

for iblock=startSpikeInfo:endSpikeInfo
   rec = SPKreadBlock(fid, iblock);
   firstIndex = 1+ (iblock-startSpikeInfo)*63;
   lastIndex = firstIndex-1+63;
   spikeTimes(firstIndex:lastIndex) = rec.data(:)/scaleFactor;
end

fclose(fid);

% now deal the spiketimes over the cells corresponding to single reps
spkSeq.spikeTime = cell(Nsubseq,Nreps);
for isub=1:Nsubseq
   for irep=1:Nreps
      reploc = RepLoc{isub,irep};
      if isequal(0,reploc.recnum*reploc.entry)
          %  sequence was interrupted - stop reading
          break
      end
      
      firstIndex = (reploc.recnum-1)*63 + reploc.entry;
      lastIndex = firstIndex - 1 + spkSeq.spikeCount(isub,irep);
      try
         spkSeq.spikeTime{isub,irep} = spikeTimes(firstIndex:lastIndex);
      catch
           % when sweq was interrupted, reploc maybe nonsensical (spilling
           % over from next seq)
          break
      end
   end
end
