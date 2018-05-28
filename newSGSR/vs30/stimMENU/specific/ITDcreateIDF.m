function idfSeq = ITDcreateIDF(carfreq, ...
   modfreq, modpercent, SPL, ...
   NdelayCycles, StepsPerCycle, PhaseComp, DelayOnMod, LeadChan, ...
   interval, duration, rise, fall, repcount, order,...
   activeChan, limchan);

stimtype = 5; % ITD stimtype index

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limchan, 0, ...
   interval, repcount);

idfSeq.indiv.stimcmn.incr_per_cycle = StepsPerCycle;
idfSeq.indiv.stimcmn.numcycles = NdelayCycles;
idfSeq.indiv.stimcmn.leadchan = LeadChan;
idfSeq.indiv.stimcmn.delayonmod = DelayOnMod;
idfSeq.indiv.stimcmn.phasecomp = PhaseComp;
idfSeq.indiv.stimcmn.duration = duration;

for k=1:2,
   idfSeq.indiv.stim{k}.spl = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.freq = DualValueOf(carfreq,k);
   idfSeq.indiv.stim{k}.modfreq = DualValueOf(modfreq,k);
   idfSeq.indiv.stim{k}.modpercent = DualValueOf(modpercent,k);
   idfSeq.indiv.stim{k}.rise = DualValueOf(rise,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fall,k);
end;
idfSeq.order = order;

%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

