function paramsOK = BMScheck;

textcolors; global StimMenuStatus SGSR
paramsOK= 0; 
% first visit all edit controls and look if their formats are OK  XXXX not ready
hh = StimMenuStatus.handles;
pp = []; pp.dummy=0; % pp must be struct before other fields can be filled as below
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur] = DurationsCheck(1); % single dur
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;

%--- BMS-sweep params
pp.carfreq = abs(UIdoubleFromStr(hh.CarFreqEdit,1));
pp.lowMod = UIdoubleFromStr(hh.LowModEdit,1);
pp.stepMod = abs(UIdoubleFromStr(hh.StepModEdit,1));
pp.highMod = UIdoubleFromStr(hh.HighModEdit,1);
pp.modDepth = abs(UIdoubleFromStr(hh.ModDepthEdit,2));
pp.stepUnit = UIintfromToggle(hh.StepUnitButton); % 1|2 = Octaves| Hz
LogSteps = isequal(pp.stepUnit,1);
%--- beat frequency
pp.beatfreq = UIdoubleFromStr(hh.BeatFreqEdit,1);
StimMenuStatus.params = pp; StimMenuStatus.paramsOK = 0;

UIinfo('Checking...');
% any non-numerical input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

% ----further param checks

% modulation sweep
somewrong=1;
if pp.lowMod<=0, UIerror('mod freqs must be positive', [hh.LowModEdit]);
else, somewrong=0;
end
if somewrong, return; end

if LogSteps,
   RelTol = 5e-2; % relative deviation of 5% is tolerated without warning
   [modFreqs, mess, newLowMod] = ...
      LogSweepChecker(pp.lowMod, pp.stepMod, pp.highMod, pp.active,...
      RelTol, 'start');
else, % Hz steps
   AbsTol = 0.5; % absolute deviation of 1 Hz is tolerated without warning
   [modFreqs, mess, newLowMod] = ...
      LinSweepChecker(pp.lowMod, pp.stepMod, pp.highMod, pp.active,...
      AbsTol, 'start');
end
switch mess
case 'ZEROSTEP',
   mess = strvcat('zero step size','but unequal start- and',...
      'end modFreq values');
   UIerror(mess, hh.StepModEdit);
   return;
case 'DIFF#STEPS',
   mess = strvcat('unequal # sweep steps','for the two channels');
   UIerror(mess, [hh.LowModEdit hh.StepModEdit hh.HighModEdit]);
   return;
case 'BIGADJUST',
   mess = strvcat('non-integer # sweep steps',...
      'between low & high mod frequencies:',...
      'low mod freq will be adjusted');
   if StimMenuWarn(mess, hh.LowModEdit), return; end;
   pp.lowMod = newLowMod;
   setstring(hh.LowModEdit, localCFS(newLowMod));
   UItextColor(hh.LowModEdit, BLACK);
case 'SMALLADJUST',
   pp.lowMod = newLowMod;
   setstring(hh.LowModEdit,localCFS(newLowMod));
end

% get # subseqs from modFreqs and report
Nsubseq = size(modFreqs,1);
if ~ReportNsubseq(Nsubseq), return; end;

% take beat freq into account
modFreqs(:,2) = modFreqs(:,1) + pp.beatfreq;
% freq range
MF = maxStimFreq;
maxMod = max(modFreqs);
if any(pp.carfreq+maxMod>MF),
   mess = ['stimulus frequencies outside 0-' num2str(MF) '-Hz range'];
   UIerror(mess, hh.CarFreqEdit);
   if pp.carfreq<=MF, % modulation frequency is accesory
      UItextColor(hh.HighModEdit, RED);
   end
   return;
end
if any(any(modFreqs<=0)),
   mess = 'non-positive modulation freqs' ;
   UIerror(mess, hh.LowModEdit);
   if all(all(modFreqs(:,1)>0)), % beat frequency is accesory
      UItextColor(hh.BeatFreqEdit, RED);
   end
   return;
end

% compute maxSPL and report
MLL = sxmMaxCarSPL(modFreqs(:,1), pp.carfreq(1), pp.modDepth(1), 'L');
MLR = sxmMaxCarSPL(modFreqs(:,end), pp.carfreq(end), pp.modDepth(end), 'R');
limlevel = updateMaxSPLinfo(MLL, MLR, modFreqs, pp.active);

% check SPLs
if any(pp.SPL>limlevel),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% durations
if any(pp.burstDur>pp.interval),
   mess = strvcat('interval too small to realize bursts');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)

global idfSeq SMS CALIB
Delay = 0;
limchan = IDFlimitChan(pp.active, modFreqs);
if LogSteps, % true LMS stimtype
   idfSeq = BMScreateIDF(pp.carfreq, ...
      pp.lowMod, pp.stepMod, pp.highMod, pp.beatfreq, pp.modDepth, ...
      pp.SPL, pp.active, limchan, ...
      pp.interval, pp.burstDur, Delay, pp.riseDur, pp.fallDur, ...
      pp.reps, pp.order);
else, % IMS with single level
   BPC = [0 pp.beatfreq]; % per-channel modfreq correction due to beat
   idfSeq = IMScreateIDF(pp.carfreq, ...
      pp.lowMod+BPC, pp.stepMod, pp.highMod+BPC, pp.modDepth, ...
      pp.SPL, pp.active, limchan, ...
      pp.interval, pp.burstDur, Delay, pp.riseDur, pp.fallDur, ...
      pp.reps, pp.order);
end

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

UIinfo('OK', -1);
StimMenuStatus.paramsOK = 1;
paramsOK= 1;

%------------------------
function s=localCFS(f);
% concise freq string
s = num2str(f,3);;
while 1,
   ee=findstr('  ',s);
   if isempty(ee), break; end;
   s(ee(1)) = '';
end
