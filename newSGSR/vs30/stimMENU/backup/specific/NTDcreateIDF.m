function idfSeq = NTDcreateIDF(lowFreq, highFreq, noise_character, SPL, ...
   start_itd, delta_itd, end_itd, rho, ...
   interval, duration, rise, fall, repcount, order,...
   activeChan, limitChan,...
   MaxSPL, RandSeed);

stimtype = 23; % NTD stimtype index

% SPL -> attenuation
% MaxSPL = mean(MaxSPL); % ignore statistical fluctuations resulting in
% tiny interaural level differences. Note: the SPLs entered in the menu are
% exact and reproducible from the data in IDF struct (via RandSeed).
% attn = round(MaxSPL - SPL);
attn = round(mean(MaxSPL) - SPL);

if length(SPL)==1, SPL = [SPL SPL]; end;
SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limitChan, SPLlim, ...
   interval, repcount);

idfSeq.indiv.stimcmn.start_itd = start_itd;
idfSeq.indiv.stimcmn.end_itd = end_itd;
idfSeq.indiv.stimcmn.delta_itd = delta_itd;
idfSeq.indiv.stimcmn.duration = duration;
% for now, only visit the "true" params  of NTD; see below
for k=1:2,
   idfSeq.indiv.stim{k}.attn = DualValueOf(attn,k);
   % idfSeq.indiv.stim{k}.attn = DualValueOf(SPL,k);
   idfSeq.indiv.stim{k}.cutoff_freq = DualValueOf(highFreq,k);
   idfSeq.indiv.stim{k}.noise_data_set = ''; % postponed; see below
   idfSeq.indiv.stim{k}.file_name = ''; % postponed
   idfSeq.indiv.stim{k}.total_pts = 0; % postponed
   idfSeq.indiv.stim{k}.sample_rate = 0; % postponed
   idfSeq.indiv.stim{k}.rise = DualValueOf(rise,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fall,k);
end;
idfSeq.order = order;

% this is a tricky menu, because the stimulus contains parameters
% that are not litterally present in the fields of the IDF struct.
% Fortunately, the IDF struct of the NTD  stimulus contains
% irrelevant fields, which we will use to store the
% extra parameters. Here is a little table:
% -------------------------------------------------------------------
%   Extra Params       Stored in field          Format      Remarks
% -------------------------------------------------------------------
%  low-freq edge      stim{1}.sample_rate      single    single value
%  interaural corr    stim{2}.sample_rate      single    single value
%  SPL                stim{i}.total_pts        single    per-channel
%  random seed        stim{2}.file_name  14-char-string  see seedToStr
% -------------------------------------------------------------------
% The low-freq edge, interaural corr and SPL are also displayed
% as strings in stim{1}.file_name and stim{1}.noise_data_set
% This is merely a service to the user (I assue these strings are
% displayed in the PDP11 analysis program)
SeedString = ['SEED=' SeedToStr(RandSeed)];
LF_maxSPLstring = ['LF' freqString(lowFreq) 'LV' num2str(round(SPL(1))) '/' num2str(round(SPL(2)))];
% LF_maxSPLstring = ['LF=' num2str(round(lowFreq)) ' Hz'];
RHOstring = ['RHO=' num2str(1e-5*round(rho*1e5))];
IDstring = 'NTD_RHO'; if noise_character==1, IDstring = [IDstring '*']; end;

idfSeq.indiv.stim{1}.sample_rate = lowFreq;
idfSeq.indiv.stim{2}.sample_rate = rho;
idfSeq.indiv.stim{1}.total_pts = SPL(1);
idfSeq.indiv.stim{2}.total_pts = SPL(2);
idfSeq.indiv.stim{1}.file_name = fixLenStr(LF_maxSPLstring,14);
idfSeq.indiv.stim{2}.file_name = fixLenStr(SeedString,14);
idfSeq.indiv.stim{1}.noise_data_set = fixLenStr(RHOstring,14);
idfSeq.indiv.stim{2}.noise_data_set = fixLenStr(IDstring,14);


%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

