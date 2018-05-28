function CompressSGSRfile(FN);
% CompressSGSRfile - compress erev data waste

Nseq = getsgsrdata(FN,'nseq');

global DEFDIRS
FNout = [DEFDIRS.IdfSpk filesep FN '_cp']; % no extension for addtosgsrdatafile

more off
for iseq = 1:Nseq,
   dd = getSGSRdata(FN, iseq);
   if isequal('erev', dd.Header.StimName) ...
         & ~isfield(dd.SpikeTimes, 'spikes'), 
      % compress old style erev 
      spikes = reconstructSPIKES(FN, iseq);
      Nsub = length(dd.SpikeTimes.SubSeq);
      for isub = 1:Nsub,
         dd.SpikeTimes.SubSeqInfo{isub} ...
            = rmfield(dd.SpikeTimes.SubSeq{isub},'Rep');
      end
      dd.SpikeTimes = rmfield(dd.SpikeTimes, 'SubSeq');
      spikes = minimizespikes(spikes);
      spikes.Buffer = codeSpikeTimes(spikes.Buffer);
      dd.SpikeTimes.spikes = spikes;
   end
   AddToSGSRdataFile(FNout, dd);
end