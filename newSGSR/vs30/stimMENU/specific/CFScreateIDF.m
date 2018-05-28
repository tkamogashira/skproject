function idfSeq = CFScreateIDF(hifreq, lofreq, deltafreq,...
   polarity, clickdur, SPL, delay, ...
   interval, duration, ...
   repcount, order,...
   activeChan, limitChan, StepUnit);

if nargin<14, StepUnit = 'lin'; end

clickdur = 1e-6*round(clickdur*1e6);

% convert polarity (-1,+1,-2,2) ->(0, 1, 2, 3)
polarity =    -1 + find(polarity==[-1 1 -2  2]);

stimtype = 19; % CFS stimtype index

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limitChan, SPLlim, ...
   interval, repcount);

idfSeq.indiv.stimcmn.polarity = polarity;

for k=1:2,
   idfSeq.indiv.stim{k}.spl = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.lofreq = DualValueOf(lofreq,k);
   idfSeq.indiv.stim{k}.hifreq = DualValueOf(hifreq,k);
   idfSeq.indiv.stim{k}.deltafreq = DualValueOf(deltafreq,k);
   
   idfSeq.indiv.stim{k}.click_dur = DualValueOf(clickdur,k);
   idfSeq.indiv.stim{k}.delay = DualValueOf(delay,k);
   
   idfSeq.indiv.stim{k}.burst_duration = DualValueOf(duration,k);
end;
idfSeq.order = order;
idfSeq = idffixorder(idfSeq,'lofreq','deltafreq','hifreq');

if isequal('log', StepUnit),
   % PDP data format does not allow for log steps;
   % indicate it in unused tape_ctl variable
   idfSeq.stimcntrl.dsid(1:3) = 'log';
end

%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

