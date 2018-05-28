function SPT = GetSpikesOfRep(iSubseq, iRep, SPIKES);

% GetSpikesOfRep - returns spike arrival times in ms of single rep
% SYNTAX:
% SPT = GetSpikesOfRep(iSubseq, iRep, SPIKES);
% (if SPIKES is not specified, global SPIKES is taken)
% SPT is vector containing the spike arrival times in ms of
% the iRep-th repetition of the iSubseq-th subsequence,
% according to PD1 clock time, *not* ET1 clock time.
% note: iSubseq counts subsequences in playing order

if nargin<3,
   global SPIKES
end

% get exact switchdur and repDur (depending on sample rate)
switchDur = SPIKES.RECORDinfo(iSubseq).switchDur; % in ms
repDur = SPIKES.RECORDinfo(iSubseq).repDur;
% get arrival times re stim start in ms, subtract switchdur
spt = SPIKES.ClockRatio*1e-3*GetSpikeTimes(iSubseq, SPIKES) - switchDur;
% if no spikes are present, we are ready
if isempty(spt), SPT=[]; return; end;
% construct  time window from iRep and repDur
startW = (iRep-1)*repDur;
endW = startW + repDur;
% filter the spikes according to this window
SPT = spt(find((spt>=startW) & (spt<endW)))-startW;
