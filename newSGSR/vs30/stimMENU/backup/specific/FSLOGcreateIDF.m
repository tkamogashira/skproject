function idfSeq = FSLOGcreateIDF(hifreq, lofreq, deltafreq,...
   modfreq, modpercent, SPL, delay, ...
   interval, duration, rise, fall, repcount, order,...
   activeChan, limitChan, StepUnit);

if ~isequal(StepUnit,'log'),
   error('non log steps');
end

stimtype = 13; % FSLOG stimtype index

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limitChan, SPLlim, ...
   interval, repcount);

for k=1:2,
   idfSeq.indiv.stim{k}.spl = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.lofreq = DualValueOf(lofreq,k);
   idfSeq.indiv.stim{k}.hifreq = DualValueOf(hifreq,k);
   idfSeq.indiv.stim{k}.deltafreq = DualValueOf(deltafreq,k);
   idfSeq.indiv.stim{k}.modfreq = DualValueOf(modfreq,k);
   idfSeq.indiv.stim{k}.modpercent = DualValueOf(modpercent,k);
   idfSeq.indiv.stim{k}.delay = DualValueOf(delay,k);
   idfSeq.indiv.stim{k}.duration = DualValueOf(duration,k);
   idfSeq.indiv.stim{k}.rise = DualValueOf(rise,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fall,k);
end;
idfSeq.order = order;
idfSeq = idffixorder(idfSeq,'lofreq','deltafreq','hifreq');

%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

