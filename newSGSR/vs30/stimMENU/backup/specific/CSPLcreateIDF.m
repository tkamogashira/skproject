function idfSeq = CSPLcreateIDF(freq, click_dur, polarity, ...
   start_spl, delta_spl, end_spl, delay, ...
   interval, duration, ...
   repcount, order,...
   activeChan, limitChan,...
   MaxSPL);

stimtype = 27; % CSPL stimtype index

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limitChan, SPLlim, ...
   interval, repcount);

% by tradition, levels are stored as (integer) attenuation values
% in CSPL idf struct.
% In SGSR, levels are specified in dB SPL
% Use convention: 120 dB SPL =def= 0 dB attenuation 
MaxSPL = 120;
loattn = round(MaxSPL-end_spl);
hiattn = round(MaxSPL-start_spl);
delattn = delta_spl.*sign(hiattn-loattn);

idfSeq.indiv.stimcmn.polarity = polarity;
for k=1:2,
   idfSeq.indiv.stim{k}.loattn = DualValueOf(loattn,k);
   idfSeq.indiv.stim{k}.hiattn = DualValueOf(hiattn,k);
   idfSeq.indiv.stim{k}.deltaattn = DualValueOf(delattn,k);
   idfSeq.indiv.stim{k}.freq = DualValueOf(freq,k);
   
   idfSeq.indiv.stim{k}.click_dur = DualValueOf(click_dur,k);
   idfSeq.indiv.stim{k}.delay = DualValueOf(delay,k);
   idfSeq.indiv.stim{k}.burst_duration = DualValueOf(duration,k);
   
end;
idfSeq.order = order;


%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

