function idfSeq = FScreateIDF(pp);

stimtype = 7; % FM stimtype index

limchan = idfLimitChan(pp.active);
SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, pp.active, limchan, pp.active, ...
   pp.interval, pp.reps);

for k=1:2,
   idfSeq.indiv.stim{k}.spl = DualValueOf(pp.SPL,k);
   idfSeq.indiv.stim{k}.fmcarrlo = DualValueOf(pp.lofreq,k);
   idfSeq.indiv.stim{k}.fmcarrhi = DualValueOf(pp.hifreq,k);
   
   idfSeq.indiv.stim{k}.sweepup = DualValueOf(pp.updur,k);
   idfSeq.indiv.stim{k}.sweepdown = DualValueOf(pp.downdur,k);
   idfSeq.indiv.stim{k}.sweephold = DualValueOf(pp.holddur,k);
      
   idfSeq.indiv.stim{k}.delay = DualValueOf(pp.delay,k);
   idfSeq.indiv.stim{k}.rise = DualValueOf(pp.riseDur,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(pp.fallDur,k);
end;
idfSeq.order = pp.order;

%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

