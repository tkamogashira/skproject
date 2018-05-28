function spikes = ReconstructSPIKES(FN, iSeq);
% ReconstructSPIKES - attempts reconstruction of SPIKES struct from EREV data
% only for EREV data
dd = getSGSRdata(FN, iSeq);
if ~isequal(dd.Header.StimName,'erev'),
   error('not an erev sequence');
end

% finding clock ratio is first challenge
% pool all spike time differences within single reps
ST = dd.SpikeTimes.SubSeq;
if ~iscell(ST), ST = {ST}; end;
Nsub = length(ST);
isi = [];
for isub=1:Nsub
   RR = ST{isub}.Rep;
   for irep=1:length(RR),
      isi = [isi 1e3*diff(RR{irep})]; % ms->us
   end
end
isi = sort(isi);
% remove zero differences
isi(find(isi==0)) = [];
if isempty(isi),
   error('no spikes');
end
qq = round(isi)./isi;
N = length(qq)
Neq = length(qq==qq(1))
if (Neq<2),
   error('insufficient data to reconstuct clockratio')
end
qq1m1 = qq(1)-1
if abs(qq1m1)>1e-3,
   error(['suspicious clock ratio: 1 + ' num2str(qq1m1)]);
end

isifix = isi*qq(1);
er = max(abs(isifix-round(isifix)))
if er>1e-2,
   error('clock ratio does not work');
end

% reconstruct stimulus in order to extract  exact switch durations etc
cleanap2(1); % avoid resetting of clock ratio due to new clock calibration
global SGSR;
SGSR.ClockRatio = 1/qq(1);
global SMS SPIKES
SMS = erev2sms(dd.Header.StimParams);
clear sms2prp
sms2prp;
initSpikeRec;
spikes = SPIKES;
% now we have to invert the action of getSpikesOfRep and
% fill SPIKES.Buffer from the stored spike times
spikes.counter = 0;
spikes.Buffer = [];
SYNCH = 5555;
for isub=1:Nsub,
   % store subseq offset
   spikes.ISUBSEQ = spikes.ISUBSEQ + 1;
   spikes.SUBSEQ(spikes.ISUBSEQ) = spikes.counter;
   spikes.counter = spikes.counter + 1;
   spikes.Buffer(spikes.counter) = SYNCH; % artificial synch pulse
   RR = ST{isub}.Rep;
   repDur = spikes.RECORDinfo(isub).repDur;
   switchDur = spikes.RECORDinfo(isub).switchDur;
   for irep=1:length(RR),
      startW = (irep-1)*repDur;
      spt = SYNCH + (RR{irep} + startW + switchDur)*(1e3/spikes.ClockRatio);
      rspt = round(spt);
      maxdev = max(abs(spt-rspt))
      if maxdev>5e-2,
         error('suspicious rounding errors');
      end
      % concatenate rspt to buffer
      Nadd = length(rspt);
      spikes.Buffer = [spikes.Buffer rspt];
      spikes.counter = spikes.counter + Nadd;
   end
end
spikes.ISUBSEQ = spikes.ISUBSEQ + 1;
spikes.SUBSEQ(spikes.ISUBSEQ) = spikes.counter;
spikes.SUBSEQ = spikes.SUBSEQ(1:Nsub+1);
spikes.BufSize = spikes.counter;

spikes.recordingComplete = dd.Header.RecordingComplete;
spikes.Nrecorded = dd.Header.NsubseqRecorded;


