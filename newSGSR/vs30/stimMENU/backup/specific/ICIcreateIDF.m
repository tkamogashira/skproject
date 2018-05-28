function idfSeq = ICIcreateIDF(SPL1,SPL2, ...
   start_ici, delta_ici, end_ici,...
   interval, click_dur, polarity, ...
   itd1, itd2,...
   repcount, order,...
   activeChan, limitChan);

stimtype = 22; % ICI stimtype index

if length(SPL1)==1, SPL1 = [SPL1 SPL1]; end;
if length(SPL2)==1, SPL2 = [SPL2 SPL2]; end;
SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limitChan, SPLlim, ...
   interval, repcount);

idfSeq.indiv.stimcmn.start_ici = start_ici;
idfSeq.indiv.stimcmn.end_ici = end_ici;
idfSeq.indiv.stimcmn.delta_ici = delta_ici;

idfSeq.indiv.stimcmn.polarity = (polarity+1)/2;
idfSeq.indiv.stimcmn.itd1 = itd1;
idfSeq.indiv.stimcmn.itd2 = itd2;

idfSeq.indiv.stimcmn.filter_freq = 0;
idfSeq.indiv.stimcmn.bandwidth = 0;
for k=1:2,
   idfSeq.indiv.stim{k}.spl1 = round(DualValueOf(SPL1,k));
   idfSeq.indiv.stim{k}.spl2 = round(DualValueOf(SPL2,k));
   idfSeq.indiv.stim{k}.click_dur = DualValueOf(click_dur,k);
end;
idfSeq.order = order;

%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

