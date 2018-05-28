function idfSeq = CTDcreateIDF(SPL, start_itd, delta_itd, end_itd,...
   interval, click_dur, polarity, ...
   repcount, order,...
   activeChan, limitChan);

stimtype = 21; % CTD stimtype index
%

% SPL -> attenuation
% MaxSPL = mean(MaxSPL); % ignore statistical fluctuations resulting in
% tiny interaural level differences. Note: the SPLs entered in the menu are
% exact and reproducible from the data in IDF struct (via RandSeed).
% attn = round(MaxSPL - SPL);
% attn = round(mean(MaxSPL) - SPL);

if length(SPL)==1, SPL = [SPL SPL]; end;
SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limitChan, SPLlim, ...
   interval, repcount);

idfSeq.indiv.stimcmn.start_itd = start_itd;
idfSeq.indiv.stimcmn.end_itd = end_itd;
idfSeq.indiv.stimcmn.delta_itd = delta_itd;

idfSeq.indiv.stimcmn.polarity = polarity;
idfSeq.indiv.stimcmn.filter_freq = 0;
idfSeq.indiv.stimcmn.bandwidth = 0;
for k=1:2,
   idfSeq.indiv.stim{k}.spl = round(DualValueOf(SPL,k));
   idfSeq.indiv.stim{k}.click_dur = DualValueOf(click_dur,k);
end;
idfSeq.order = order;

%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

