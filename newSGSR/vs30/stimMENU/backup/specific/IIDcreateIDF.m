function idfSeq = IIDcreateIDF(carfreq, ...
   modfreq, modpercent, maxSPL, ...
   meanSPL, stepIID, activeChan, limChan, ...
   interval, duration, delay, rise, fall, repcount, order);

stimtype = 4; % IID stimtype index

BOTH = 0; % numerical value for "Both  channels"

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limChan, BOTH, ...
   interval, repcount);

idfSeq.indiv.stimcmn.meanspl = meanSPL;
idfSeq.indiv.stimcmn.hispl = maxSPL;
idfSeq.indiv.stimcmn.deltaspl = stepIID;

for k=1:2,
   idfSeq.indiv.stim{k}.freq = DualValueOf(carfreq,k);
   idfSeq.indiv.stim{k}.modfreq = DualValueOf(modfreq,k);
   idfSeq.indiv.stim{k}.modpercent = DualValueOf(modpercent,k);
   idfSeq.indiv.stim{k}.delay = DualValueOf(delay,k);
   idfSeq.indiv.stim{k}.duration = DualValueOf(duration,k);
   idfSeq.indiv.stim{k}.rise = DualValueOf(rise,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fall,k);
end;
idfSeq.order = order;

%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

