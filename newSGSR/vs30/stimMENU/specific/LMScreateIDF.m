function idfSeq = LMScreateIDF(carFreq, ...
   lowMod, stepMod, highMod, modDepth, ...
   SPL, activeChan, limchan, ...
   interval, burstDur, delay, riseDur, fallDur, ...
   repcount, order);

stimtype = 16; % LMS stimtype index

BOTH = 0; % numerical value for "Both  channels"

idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limchan, BOTH, ...
   interval, repcount);

for k=1:2,
   idfSeq.indiv.stim{k}.spl = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.carrierfreq = DualValueOf(carFreq,k);
   
   idfSeq.indiv.stim{k}.lomodfreq = DualValueOf(lowMod,k);
   idfSeq.indiv.stim{k}.himodfreq = DualValueOf(highMod,k);
   idfSeq.indiv.stim{k}.deltamodfreq = DualValueOf(stepMod,k);
   idfSeq.indiv.stim{k}.modpercent = DualValueOf(modDepth,k);
   
   idfSeq.indiv.stim{k}.delay = DualValueOf(delay,k);
   idfSeq.indiv.stim{k}.duration = DualValueOf(burstDur,k);
   idfSeq.indiv.stim{k}.rise = DualValueOf(riseDur,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fallDur,k);
end;
idfSeq.order = order;
idfSeq = idffixorder(idfSeq,'lomodfreq','deltamodfreq','himodfreq');


%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

