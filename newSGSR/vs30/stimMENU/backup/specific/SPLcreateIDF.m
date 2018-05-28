function idfSeq = SPLcreateIDF(carFreq, ...
   modFreq, modDepth, ...
   startSPL, stepSPL, endSPL, ...
   activeChan, limchan, ...
   interval, burstDur, delay, riseDur, fallDur, ...
   repcount, order);

stimtype = 2; % SPL stimtype index

% fix for problems in analysis program suggested by Ranjan
[startSPL, endSPL, stepSPL, order] = ...
   localFixStepSign(startSPL, stepSPL, endSPL, order); 

BOTH = 0; % numerical value for "Both  channels"

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limchan, BOTH, ...
   interval, repcount);

for k=1:2,
   idfSeq.indiv.stim{k}.lospl = DualValueOf(startSPL,k);
   idfSeq.indiv.stim{k}.hispl = DualValueOf(endSPL,k);
   idfSeq.indiv.stim{k}.deltaspl = DualValueOf(stepSPL,k);
   idfSeq.indiv.stim{k}.freq = DualValueOf(carFreq,k);
   idfSeq.indiv.stim{k}.modfreq = DualValueOf(modFreq,k);
   idfSeq.indiv.stim{k}.modpercent = DualValueOf(modDepth,k);
   idfSeq.indiv.stim{k}.delay = DualValueOf(delay,k);
   idfSeq.indiv.stim{k}.duration = DualValueOf(burstDur,k);
   idfSeq.indiv.stim{k}.rise = DualValueOf(riseDur,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fallDur,k);
end;
idfSeq.order = order;


%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

function [startSPL, endSPL, stepSPL, order] = ...
   localFixStepSign(startSPL, stepSPL, endSPL, order); 
% fix for analysis program suggested by Ranjan
% purpose is to 1) always make endSPL the  SPL of the first 
%                  subseq; this is done by always using
%                  the "reverse" order
%               2) adapt the sign of stepSPL so that 
%                  pos step <--> decreasing SPL
if order==2, return; % random order, nothing we can do
elseif order==1, % forward
   [startSPL, endSPL] = swap(startSPL, endSPL);
   order = 0; % reverse
end
% now the order is always reverse. Check the sign of step
stepSPL = abs(stepSPL).*sign(endSPL - startSPL);





