function idfSeq = BBcreateIDF(carFreq, modFreq, modDepth, ...
   lowBeat, stepBeat, highBeat, varChan, beatOnMod,...
   SPL, activeChan, limchan, ...
   interval, burstDur, riseDur, fallDur, ...
   repcount, order);

stimtype = 6; % BB stimtype index

BOTH = 0; % numerical value for "Both  channels"

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limchan, BOTH, ...
   interval, repcount);

idfSeq.indiv.stimcmn.duration = burstDur;
idfSeq.indiv.stimcmn.carrierfreq = carFreq;
idfSeq.indiv.stimcmn.modfreq = modFreq;
idfSeq.indiv.stimcmn.hibeatfreq = highBeat;
idfSeq.indiv.stimcmn.lobeatfreq = lowBeat;
idfSeq.indiv.stimcmn.deltabeatfreq = stepBeat;
idfSeq.indiv.stimcmn.beatonmod = beatOnMod;
idfSeq.indiv.stimcmn.var_chan = varChan;

for k=1:2,
   idfSeq.indiv.stim{k}.spl = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.modpercent = DualValueOf(modDepth,k);
   idfSeq.indiv.stim{k}.rise = DualValueOf(riseDur,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fallDur,k);
end;
idfSeq.order = order;
idfSeq = idffixorder(idfSeq,'lobeatfreq','deltabeatfreq','hibeatfreq');


%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

