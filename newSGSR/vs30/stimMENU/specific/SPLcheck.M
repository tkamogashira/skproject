function paramsOK = SPLcheck;

textcolors; global StimMenuStatus SGSR
paramsOK= 0; 
% first visit all edit controls and look if their formats are OK  XXXX not ready
hh = StimMenuStatus.handles; 
pp = []; pp.dummy=0; % pp must be struct before other fields can be filled as below
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur pp.delay] = DurationsCheck;
if ~durOK, return; end;
%--- modulation
[modOK, pp.modDepth, pp.modFreq, modPresent] = ModulationCheck;
if ~modOK, return; end;


%--- SPL-sweep params 
[pp.active, acOK] = activeChanCheck;
if ~acOK, return; end
pp.carfreq = abs(UIdoubleFromStr(hh.CarFreqEdit,2));
pp.startSPL = UIdoubleFromStr(hh.StartSPLEdit,2);
pp.stepSPL = abs(UIdoubleFromStr(hh.StepSPLEdit,2));
pp.endSPL = UIdoubleFromStr(hh.EndSPLEdit,2);
rmess = strvcat( 'For historical reasons,', 'all SPLs must be integer values');
nih = [];
if ~isequal(pp.startSPL,round(pp.startSPL)), 
   nih = [nih, hh.StartSPLEdit];
end
if ~isequal(pp.endSPL,round(pp.endSPL)),
   nih = [nih, hh.EndSPLEdit];
end
if ~isequal(pp.stepSPL,round(pp.stepSPL)),
   nih = [nih, hh.StepSPLEdit];
end
if ~isempty(nih),
   UIerror(rmess, nih);
   return;
end
StimMenuStatus.params = pp; StimMenuStatus.paramsOK = 0;

UIinfo('Checking...');
% any non-numerical input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

% ----further param checks
% freq range
MF = maxStimFreq;
if any((pp.carfreq+modPresent*abs(pp.modFreq))>MF),
   mess = ['frequencies outside 0-' num2str(MF) '-Hz range'];
   UIerror(mess, hh.CarFreqEdit);
   if pp.carfreq<=MF, % modulation frequency is accesory
      UItextColor(hh.ModFreqEdit, RED);
   end
   return;
end

% SPL sweep
[SPLsweepOK, SPL] = SPLsweepchecker(pp, hh);
if ~SPLsweepOK, return; end;

% get # subseqs from SPL and report
Nsub = size(SPL,1);
if ~ReportNsubSeq(Nsub), return; end;

% compute maxSPL and report
if ~modPresent,
   [dd ifilt] = safeSamplefreq(max(pp.carfreq));
   MLL = maxNumToneLevel - calibrate(pp.carfreq(1),ifilt,'L');
   MLR = maxNumToneLevel - calibrate(pp.carfreq(end),ifilt,'R');
else,
   MLL = sxmMaxCarSPL(pp.modFreq(1), pp.carfreq(1), pp.modDepth(1), 'L');
   MLR = sxmMaxCarSPL(pp.modFreq(end), pp.carfreq(end), pp.modDepth(end), 'R');
end
limlevel = updateMaxSPLinfo(MLL, MLR, pp.carfreq, pp.active);

% check SPLs
if any(max(SPL)>limlevel),
   UIerror('level(s) too high');% where is that max level
   errorSPL = max(max(SPL));
   if any(pp.endSPL==errorSPL), UItextColor(hh.EndSPLEdit, RED); end;
   if any(pp.startSPL==errorSPL), UItextColor(hh.StartSPLEdit, RED); end;
   return;
end;

% durations
if any((abs(pp.delay) + pp.burstDur)>pp.interval),
   mess = strvcat('interval too small to realize bursts',...
      'and interaural delays');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)

global idfSeq SMS CALIB
limchan = idfLimitChan(pp.active, SPL);
idfSeq = SPLcreateIDF(pp.carfreq, ...
   pp.modFreq, pp.modDepth, ...
   pp.startSPL, pp.stepSPL, pp.endSPL, ...
   pp.active, limchan, ...
   pp.interval, pp.burstDur, pp.delay, pp.riseDur, pp.fallDur, ...
   pp.reps, pp.order);


SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

UIinfo('OK', -1);
ReportPlayTime(idfSeq,Nsub);
StimMenuStatus.paramsOK = 1;
paramsOK= 1;

