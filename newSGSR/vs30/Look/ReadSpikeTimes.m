function spt  = ReadspikeTimes(FN, iSeq);
% get spike times of iSeq as a Nsub x Nrep cell matrix
%  SYNTAX: spt = SGSRspikeTimes(FN, iSeq):
%  spt{isub, irep} is vector containing spike times in ms of
%  irep-th repetion of isub-th subsequence.
%
%  Convention: Iseq>0 -> SPK format
%              Iseq<0 -> SGSR format
%              

if iSeq>0, % SPK format
   spt = spkget(FN,iSeq);
   spt = spt.spikeTime;
else, % SGSR format
   dd=getSGSRdata(FN, iSeq);
   Nsub = dd.Header.Nsubseq;
   NsubRec = dd.Header.NsubseqRecorded;
   Nrep = dd.SpikeTimes.spikes.RECORDinfo.Nrep;
   
   spt = cell(Nsub,Nrep);
   for isub=1:NsubRec,
      for irep=1:Nrep,
         spt{isub,irep} = getSpikesOfRep(isub,irep,dd.SpikeTimes.spikes);
      end
   end
end
   
   