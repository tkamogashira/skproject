function idfSeq = NSPLcreateIDF(lowFreq, highFreq, noise_character, ...
   start_spl, delta_spl, end_spl, rho,  delay, ...
   interval, duration, rise, fall, ...
   repcount, order,...
   activeChan, limitChan,...
   MaxSPL, RandSeed, npol);

stimtype = 25; % NSPL stimtype index

SPLlim = 0; % meaningless default
idfSeq.stimcntrl = CreateStimCntrl(stimtype, currentIDFindex,...
   contraChan, activeChan, limitChan, SPLlim, ...
   interval, repcount);

% make sure all spl-related variables are double valued
if length(MaxSPL)==1, MaxSPL=[MaxSPL MaxSPL]; end;
[start_spl, delta_spl, end_spl, MaxSPL] = ...
   equalizeSize(start_spl, delta_spl, end_spl, MaxSPL);

% by tradition, levels are stored as (integer) attenuation values
% in NSPL idf struct.
% Note: the SPLs entered in the menu are
% exact and reproducible from the data in IDF struct (via RandSeed).
loattn = round(MaxSPL-end_spl);
hiattn = round(MaxSPL-start_spl);
delattn = delta_spl.*sign(hiattn-loattn);

% for now, only visit the "true" params  of NTD; see below
for k=1:2,
   idfSeq.indiv.stim{k}.loattn = DualValueOf(loattn,k);
   idfSeq.indiv.stim{k}.hiattn = DualValueOf(hiattn,k);
   idfSeq.indiv.stim{k}.delattn = DualValueOf(delattn,k);
   idfSeq.indiv.stim{k}.cutoff_freq = DualValueOf(highFreq,k);
   idfSeq.indiv.stim{k}.delay = DualValueOf(delay,k);
   idfSeq.indiv.stim{k}.duration = DualValueOf(duration,k);
   
   idfSeq.indiv.stim{k}.noise_data_set = ''; % postponed; see below
   idfSeq.indiv.stim{k}.file_name = ''; % postponed
   idfSeq.indiv.stim{k}.total_pts = 0; % postponed
   idfSeq.indiv.stim{k}.sample_rate = 0; % postponed
   
   idfSeq.indiv.stim{k}.rise = DualValueOf(rise,k);
   idfSeq.indiv.stim{k}.fall = DualValueOf(fall,k);
end;
idfSeq.indiv.noise_character = [noise_character, noise_character];
idfSeq.order = order;

% this is a tricky menu, because the stimulus contains parameters
% that are not litterally present in the fields of the IDF struct.
% Fortunately, the IDF struct of the NSPL  stimulus contains
% irrelevant fields, which we will use to store the
% extra parameters. Here is a little table:
% -------------------------------------------------------------------
%   Extra Params       Stored in field          Format      Remarks
% -------------------------------------------------------------------
%  low-freq edge      stim{1}.sample_rate      single    single value
%  interaural corr    stim{2}.sample_rate      single    single value
%  loSPL              stim{i}.total_pts        single    per-channel
%  random seed        stim{2}.file_name  14-char-string  see seedToStr
% -------------------------------------------------------------------
% The low-freq edge, interaural corr and SPL are also displayed
% as strings in stim{1}.file_name and stim{1}.noise_data_set
% This is merely a service to the user (I assume these strings are
% displayed in the PDP11 analysis program)
SeedString = ['SEED=' SeedToStr(RandSeed)];
PolStr = '+-';
LF_maxSPLstring = ['L' freqString(lowFreq) 'S' ...
      num2str(round(start_spl(1))) '/' num2str(round(start_spl(2))) 'P' PolStr(round((3-npol)/2))];
% LF_maxSPLstring = ['LF=' num2str(round(lowFreq)) ' Hz'];
RHOstring = ['RHO=' num2str(1e-5*round(rho*1e5))];
IDstring = 'NSPL_RHO'; if noise_character==1, IDstring = [IDstring '*']; end;

idfSeq.indiv.stim{1}.sample_rate = lowFreq;
idfSeq.indiv.stim{2}.sample_rate = rho;
idfSeq.indiv.stim{1}.total_pts = start_spl(1);
idfSeq.indiv.stim{2}.total_pts = start_spl(2);
idfSeq.indiv.stim{1}.file_name = fixLenStr(LF_maxSPLstring,14);
idfSeq.indiv.stim{2}.file_name = fixLenStr(SeedString,14);
idfSeq.indiv.stim{1}.noise_data_set = fixLenStr(RHOstring,14);
idfSeq.indiv.stim{2}.noise_data_set = fixLenStr(IDstring,14);


%--------locals---------
function d=DualValueOf(a,k);
if size(a,2)==1, d = a;
else, d = a(k); 
end

