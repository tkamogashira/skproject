function [spikeRate, VS, ALPHA] = GetSpikeStats(iSubseq, fwindow, SPIKES, VSfreq);

% ReadSpikeStats - returns number of spikes of subs within window XXX remove superfluous args
% INPUTS:
%    iSubseq is subseq number
%    Nrep is # reps in subseq
%    fwindow is window (interval) for accepting spike counts;
%       fwindow  is [t0 t1] re start of rep in ms
% OUTPUT:
% spikeRate is mean spikes/s within window
if nargin<3,
   global SPIKES
end
% get exact switchDur and repDur (depending on sample rate)
switchDur = SPIKES.RECORDinfo(iSubseq).switchDur;
repDur = SPIKES.RECORDinfo(iSubseq).repDur;
% # repetitions
Nrep = SPIKES.RECORDinfo(iSubseq).Nrep;

% get all spike times in us re onset of 1st rep
spt = 1e-3*getSpikeTimes(iSubseq, SPIKES) - switchDur; % us->ms
% remove posthoc spikes (they might be wrapped into valid arrival times below)
spt = spt(find(spt<=Nrep*repDur));
% wrap reps
spt = rem(spt, repDur);
% if asked for a incomplete subsequence, return 0
if isempty(spt), spikeRate = 0; return; end;
% find total time in s (!) during which spikes are accepted
recDur = Nrep*1e-3*(fwindow(2)-fwindow(1));
% select spikes within window and convert to spike rate
sptw = find((spt>=fwindow(1)) & (spt<=fwindow(2)));
Nspikes = length(sptw);
spikeRate = Nspikes/recDur;

if nargout>1,
   VS = VSfreq;
   APLPHA = VSfreq;
   fns = fieldnames(VSfreq);
   for ii=1:length(fns),
      fn = fns{ii};
      freq = getfield(VSfreq,fn);
      freq = freq(min(end,iSubseq));
      [R, alpha] = VectorStrength(sptw, freq);
      eval(['VS.' fn ' = R;']);
      eval(['ALPHA.' fn ' = alpha;']);
   end
end
   
   
   