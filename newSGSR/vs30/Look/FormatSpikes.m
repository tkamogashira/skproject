function spikeTime = FormatSpikes(SPIKES);
% FormatSpikes - put raw spike times from SPIKES buffer into cell matrix
if nargin<1, 
   global SPIKES
end

NvarValues = length(SPIKES.RECORDinfo);
Nrep = SPIKES.RECORDinfo(1).Nrep;
Nrec = SPIKES.ISUBSEQ-1;

spkSeq.spikeTime = cell(NvarValues, Nrep);
for isubseq=1:Nrec,
   for iRep=1:Nrep,
      spt = GetSpikesOfRep(isubseq, iRep, SPIKES);
      spikeTime{isubseq, iRep} = spt;
   end
end
