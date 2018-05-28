function idfSeq = IMScreateIDF(carFreq, ...
   lowMod, stepMod, highMod, modDepth, ...
   SPL, activeChan, limchan, ...
   interval, burstDur, delay, riseDur, fallDur, ...
   repcount, order);

% create IdfSeq struct for IMS stimtype. Note: SPL sweep is not used,
% i.e., spl is always kept constant

stimtype = 11; % IMS stimtype index

BOTH = 0; % numerical value for "Both  channels"

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limchan, BOTH, ...
   interval, repcount);

for k=1:2,
   idfSeq.indiv.stim{k}.lospl = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.hispl = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.deltaspl = 10; % meaningless default value
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

