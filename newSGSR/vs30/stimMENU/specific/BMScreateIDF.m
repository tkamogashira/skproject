function idfSeq = BMScreateIDF(carFreq, ...
   lowMod, stepMod, highMod, beatFreq, modDepth, ...
   SPL, activeChan, limchan, ...
   interval, burstDur, delay, riseDur, fallDur, ...
   repcount, order);

stimtype = 18; % BMS stimtype index

BOTH = 0; % numerical value for "Both  channels"

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limchan, BOTH, ...
   interval, repcount);

idfSeq.indiv.stimcmn.carrierfreq = carFreq;
idfSeq.indiv.stimcmn.lomodfreq = lowMod;
idfSeq.indiv.stimcmn.himodfreq = highMod;
idfSeq.indiv.stimcmn.deltamodfreq = stepMod;
idfSeq.indiv.stimcmn.beatfreq = beatFreq;
idfSeq.indiv.stimcmn.duration = burstDur;
for k=1:2,
   idfSeq.indiv.stim{k}.spl = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.modpercent = DualValueOf(modDepth,k);
   idfSeq.indiv.stim{k}.rise = DualValueOf(riseDur,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fallDur,k);
end;
idfSeq.order = order;


%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end
