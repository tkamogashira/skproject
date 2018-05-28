function OK = BFScheck;

% Checks params for BFSmenu and stores the stimulus info in
% globals idfSeq and SMS  (PDP11 and SGSR formats, resp)
% SGSR version 06 & higher
% note: PRPstatus must be initialized at entry

global StimMenuStatus SGSR PRPstatus

OK = 0;
hh = StimMenuStatus.handles;
NoLogSweeps = 1;

UIinfo('Checking parameters...');

% fix StepFreqButton to only handle Hz steps
% (as far as I know, there is no BFSLOG stim menu)
uitoggle(hh.StepFreqButton, 'Hz');
set(hh.StepFreqButton, 'tooltipstring','');
set(hh.StepFreqButton, 'enable','inactive');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- frequency sweep params
[fsOK, pp.lofreq, pp.dfreq, pp.hifreq, cfreqs, Nseq] = frequencySweepCheck(1);
if ~fsOK, return; end;
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur] = DurationsCheck;
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;
% beat frequency
pp.beatfreq = UIdoubleFromStr(hh.BeatFreqEdit,1);
if ~checkNanAndInf(pp), return; end

% check if realization of beat freq brings us outside freq range
MF = maxStimFreq;
highestFreq = pp.hifreq + max(0,pp.beatfreq);
if highestFreq>MF,
   mess = strvcat(['Frequencies too high. '],...
      ['High freq limit is ' num2str(MF) ' Hz']);
   UIerror(mess, [hh.HighFreqEdit hh.BeatFreqEdit]);
end

% durations
if any(pp.burstDur>pp.interval),
   mess = strvcat('interval too small to realize bursts');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
leftActive = ~isequal(pp.active,2); 
rightActive = ~isequal(pp.active,1);
MLleft = NaN; MLright = NaN;
if leftActive, MLleft = maxNumToneLevel - calibrate(cfreqs, NfiltInsetup ,'L'); end;
if rightActive, MLright = maxNumToneLevel - calibrate(cfreqs+pp.beatfreq, NfiltInsetup, 'R'); end;
limlevel = updateMaxSPLinfo(MLleft, MLright, cfreqs, pp.active,1);

% SPLs
if any(pp.SPL>limlevel),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

StimMenuStatus.params = pp;

global idfSeq SMS CALIB;
limchan = idfLimitChan(pp.active, cfreqs);
idfSeq = BFScreateIDF(pp.hifreq, pp.lofreq, pp.dfreq, pp.beatfreq, ...
   pp.SPL, pp.interval, pp.burstDur, pp.riseDur, pp.fallDur, ...
   pp.reps, pp.order,...
   pp.active, limchan);
SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);

