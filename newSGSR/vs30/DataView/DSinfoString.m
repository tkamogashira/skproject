function [S, ST] = DSinfoString(ds)
% DSinfoString - summary of ID and parameters of dataset
%   S = DSinfoString(DS) is a 1x7 cell array of strings
%   summarizing the ID and parameters of dataset DS.
%   All strings contain a trailing space to facilitate GUI rendering.
%
%   The following table explains what the strings S{k} contain:
%     k       content           Example     comment
%    ------------------------------------
%     1   dataset seq n          -42     (negative means IDF/SPK)
%     2   seq ID string       <13-22-FS>  (<stimtype> if no seq ID)
%     3     carrier freq        200/250 Hz
%         or noise cutoffs    100-3000 Hz
%     4        SPL              30/40 dB
%     5     stimulus-specifics   F, rho=0.95  (noise params)
%                              25 Hz, 100%  (modulation params)
%                                100 us       (click duration)
%                              myWavList   (filename of wavlist)
%     6    timing      4* x 20 x 1000/1300 ms (asterisk: incomplete rec)
%     7    DAchan                B
%
%   [S, ST] = DSinfoString(DS) also returns a struct ST whose fields are
%   the cells os S, viz: iseqStr, IDstr, Fstr, SPLstr, SPstr, Tstr, DAstr.
%
%   See also showStimParam.

persistent knownTypes % put in cache - menufiglist is time-consuming

if isempty(knownTypes),
   idfTypes = {'fs'   'spl'   'iid'   'itd'   'bb'   'fm'   ...
         'ims'   'fslog' 'bfs'  'lms'   'bms'  'cfs' ...
         'ctd'   'ici'   'ntd'  'nspl'  'cspl' };
   knownTypes = unique([idfTypes menufigList]);
end
stimType = lower(ds.stimtype); 


pars = localCleanIDFpar(ds.spar);
parlist = lower(fieldnames(pars)); % lowercase names of all stim params

% --- seq number
iseqStr= [num2sstr(ds.iseq) ' '];

% --- seq ID string
IDstr= [ds.seqid ' '];

% --- freq info
Fstr = paramString(ds.fcar, 'Hz '); % carrier freq
Fstrk = paramString(deciRound(ds.fcar/1e3,3), 'kHz '); % % try kHz, may be shorter
if length(Fstrk)<length(Fstr), Fstr = Fstrk; end
if isequal('bb', stimType), Fstr = paramString(ds.carrierfreq, 'Hz '); 
elseif isequal('bn', stimType), 
   if ds.midfreq<10e3
       Fstr = paramstring(ds.midfreq, 'Hz ');
   else
       Fstr = paramString(deciround(ds.midfreq/1e3,3), 'kHz ');
   end
end
if isempty(Fstr), % try to find noise cutoffs
   Fstr = '***** ';
   if ~isempty(strmatch('flow', parlist, 'exact'))
      Fstr = paramString([ds.flow; ds.fhigh], 'Hz ', '** ');
      Fstr = strsubst(Fstr, '::', '~');
   elseif ~isempty(strmatch('lowfreq', parlist, 'exact'))
      Fstr = paramString([ds.lowfreq; ds.highfreq], 'Hz ', '** ');
      Fstr = strsubst(Fstr, '::', '~');
   elseif ~isempty(strmatch('noiself', parlist, 'exact'))
      Fstr = paramString([ds.NoiseLF; ds.NoiseHF], 'Hz ', '** ');
      Fstr = strsubst(Fstr, '::', '~');
   elseif ~isempty(strmatch('tonefreq', parlist, 'exact'))
      Fstr = paramString(ds.ToneFreq, 'Hz ');
   end
end

% --- SPL info
SPLstr = '***** ';
if ~isempty(strmatch('spl', parlist, 'exact'))
   SPLstr = paramString(ds.spl, 'dB ');
elseif ~isempty(strmatch(stimType, {'nspl' 'spl' 'cspl'}))
   SPLstr = paramString(ds.xval, 'dB ');
elseif isequal('erev', stimType)
   SPLstr = [paramstring(ds.SPLtone) '&' paramstring(ds.SPLnoise(:),'dB ')];
elseif isequal('ici', stimType)
   SPLstr = [paramstring(ds.SPL1) '&' paramstring(ds.SPL2(:),'dB ')];
elseif isequal('iid', stimType)
   SPLstr = paramstring(ds.meanSPL, 'dB ');
elseif isequal('tts', stimType)
   SPLstr = [paramstring(ds.probeSPL) '&' paramstring(ds.xval,'dB ')];
end
if length(SPLstr)<7, SPLstr = [SPLstr ' ']; end

% --- timing
% 4/5 x 20 x 1000/1300 ms
if ~isequal(ds.nrec, ds.nsub), qqq='*'; else qqq=''; end
Tstr = [num2sstr(ds.nrec) qqq ' x ' num2sstr(ds.nrep) ' x ' ];
if isequal('bn', stimType)
   Tstr = [Tstr, paramString(round(ds.burstdur/1e3), '', '* ')];
   Tstr = [Tstr, '/' num2sstr(round(ds.repdur/1e3)) ' s '];
else
   Tstr = [Tstr, paramString(ds.burstdur, '', '* ')];
   Tstr = [Tstr, '/' num2sstr(ds.repdur) ' ms '];
end

% --- DA channel
DAstr = [channelChar(ds.DAchan) ' '];
if isequal('bn', stimType) % if binaural zwuis, add no-noise channel if applicable
   if isequal(0,ds.DAchan)
      nnChan = channelChar(3-ds.NoiseEar);
      DAstr = [channelChar(ds.DAchan) '/' nnChan];
   end
end
try
    SPstr = localSpec(ds, stimType, knownTypes);
catch
    SPstr = '**???**';
end
if ~isequal(' ', SPstr(end)), SPstr = [SPstr ' ']; end

% collect whole thing in cell array and in struct 
S = {iseqStr, IDstr, Fstr, SPLstr, SPstr, Tstr, DAstr};
ST = CollectInStruct(iseqStr, IDstr, Fstr, SPLstr, SPstr, Tstr, DAstr);

%====locals==============================

function S = localCleanIDFpar(idfSeq)
% put idfSeq struct in simpler, non-hierarchic struct
if ~isfield(idfSeq, 'stimcntrl'), % non-IDF, return unchanged
   S = idfSeq;
   return;
end
stim = idfSeq.indiv.stim{1};
stim2 = idfSeq.indiv.stim{2};
FNS = fieldnames(stim);
for ii=1:length(FNS),
   fn = FNS{ii};
   eval(['stim.' fn ' = [stim.' fn ' stim2.' fn '];']);
end
S = combineStruct(idfSeq.stimcntrl, stim);
idfSeq = rmfield(idfSeq, {'stimcntrl' 'indiv'});
% include extra fields of idfSeq
S = combineStruct(S, idfSeq); 

function S = localSpec(ds, stimType, knownTypes)
% stimulus-type specifics
S = '*** ';
switch stimType,
case 'armin',
   Fflip = sort(ds.xval);
   if ds.AKversion>2, % remove endpoints=noise cutoffs
      Fflip = Fflip(2:end-1);
   end
   S = paramstring(Fflip(:), 'Hz ');
   polC = '- +';
   ipol = 2+double([ds.polalow ds.polahigh]);
   S = [S channelChar(ds.VarEar) polC(ipol)];
case 'bb',
   if ds.beatonmod
      mstr = paramstring(ds.modfreq, 'mod; ');
      S = [mstr paramstring(ds.fbeatmod, 'Hz ')];
   else
      S = ['car ' paramstring(ds.fbeat, 'Hz ')];
   end
case 'bert',
   S = [num2sstr(ds.noiseLF) '~' num2sstr(ds.noiseHF) ' Hz  ' num2sstr(ds.modDepth) '% '];
case 'bfs',
   S = paramstring(ds.fbeat, 'Hz beat');
case 'bms',
   S = [paramstring(ds.fmod(:,1), 'Hz ') paramstring(ds.fbeatmod, 'Hz') ' bb '];
case 'bn',
   S = [num2sstr(ds.Ncomp) '/' num2sstr(ds.MeanSepa) '/' num2sstr(ds.DDfreq) ' '];
   try
      if length(ds.TiltStr)>7, S = [bracket(ds.TiltStr(1:min(end,18)), 1, '''''') ' ']; end
   end % try
case {'cfs', 'cspl'},
   S = paramstring(ds.click_dur, 'us ');
   polC = {'-' '+' '-+'  '+-'};
   ipol = 1+round(ds.polarity);
   S = [S, polC{ipol}];
case 'ctd',
   S = paramstring(ds.xval, 'us ');
   S = [S paramstring(ds.click_dur, 'us ')];
   polC = {'-' '+' '-+'  '+-'};
   ipol = 1+round(ds.polarity);
   S = [S, polC{ipol}];
case 'erev',
   S = paramstring(ds.noiseBW, 'Hz BW ');
case 'fm',
case {'fs' 'fslog'},
   if all(ds.fmod==0)
       S = 'no mod';
   else
       S = [paramstring(ds.fmod) 'Hz mod, ' paramstring(ds.modpercent) '% ' ];
   end
case 'ici',
   S = paramstring(ds.xval, 'ms ici ');
   S = [S paramstring(ds.click_dur, 'us ')];
   polC = {'-' '+' '-+'  '+-'};
   ipol = 1+round(ds.polarity);
   S = [S, polC{ipol}];
case 'iid',
   S = paramstring(ds.xval, 'dB ');
case 'ims',
   S = [paramstring(ds.xval) 'Hz,' paramstring(ds.modpercent) '% '];
case 'itd',
   S = paramstring(ds.xval, 'us ');
case 'lms',
   S = [paramstring(ds.xval) 'Hz,' paramstring(ds.modpercent) '% '];
case 'nrho',
   S = ['rho=' paramstring(ds.xval) ' '];
case 'nspl',
   polC = '- +';
   ipol = 2+round(ds.noiseSign);
   S = ['rho=' num2sstr(ds.rho), ' ' polC(ipol) ' '];
case 'ntd',
   S = [paramString(ds.xval) ' us rho=' num2sstr(ds.rho)];
case 'ps',
   S = ['N=' num2sstr(ds.Nphase) ' '];
case 'spl',
   if all(ds.fmod==0)
       S = 'no mod';
   else
       S = [paramstring(ds.fmod, 'Hz mod, ') paramstring(ds.modpercent) '% ' ];
   end
case 'thr',
   S = ['+' num2sstr(ds.critVal) ' ' ds.critMode ' '];
case 'tts',
   S = ['Fsup=' paramString(ds.suppfreq, 'Hz ')];
case 'wav',
   S = [ds.wavlistname '.wavlist '];
otherwise,
   if ~isequal('EDF', ds.FileFormat), % don't warn for EDF zoo
      warning(['Detailed dataset info on stimulus type ''' stimType ''' is not available.']);
   end
   S = '**??** ';
end
