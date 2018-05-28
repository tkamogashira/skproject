function OK = NSPLcheck;

% QNSPLcheck
% Checks params for NSPLmenu and stores the stimulus info in
% globals idfSeq and SMS  (PDP11 and SGSR formats, resp)
% SGSR version 08 & higher
% note: PRPstatus must be initialized at entry

global StimMenuStatus SGSR PRPstatus
persistent Rseed
if isempty(Rseed), % initial call to NTDcheck -> initialize Rseed
   Rseed = SetRandState; % this way, the max SPL values will
   % .. not fluctuate from try to try
end
textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles; 
UIinfo('Checking parameters...');
set([hh.IPDUnit hh.IPDEdit],'visible', 'off', 'string', '0');
uitoggle(hh.PolarityButton,'+','-');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur pp.delay] = DurationsCheck; % dual dur values allowed
if ~durOK, return; end;
%--- generic noise parameters
[fbOK, pp.lowFreq, pp.highFreq, pp.rho, pp.noisechar] = NoiseParamChecker;
if ~fbOK, return; end;
%--- SPL-sweep params 
pp.startSPL = UIdoubleFromStr(hh.StartSPLEdit,2);
pp.stepSPL = abs(UIdoubleFromStr(hh.StepSPLEdit,2));
pp.endSPL = UIdoubleFromStr(hh.EndSPLEdit,2);
[pp.active, acOK] = activeChanCheck;
if ~acOK, return; end
%--- Rseed & polarity
if NsplExtra('enabled'),
   [XtraOK, Rseed, pp.noisePolarity] = NsplExtra;
   if ~XtraOK, return; end
else, pp.noisePolarity = 1; % default: no reversed phases
end

% any non-numerical or oversized input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;
% SPL sweep
[SPLsweepOK, SPL] = SPLsweepchecker(pp, hh);
if ~SPLsweepOK, return; end;

StimMenuStatus.params = pp;

% get and report # subseqs
Nspl = size(SPL,1);
if ~ReportNsubSeq(Nspl), return; end;

% now start more sophisticated param checks
% interval / duration
noiseDur = max(abs(pp.delay))+ max(pp.burstDur);
if (noiseDur>pp.interval),
   mess = strvcat('interval too small to realize bursts',...
      'and interaural delays');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% initialize noise buffer to get maximum SPL. Distinguish frozen & running noise
if isequal(pp.noisechar, 0), % frozen noise
   [dummy maxLevel] = gaussNoiseBand(pp.lowFreq, pp.highFreq, ...
   noiseDur, 0, pp.active, pp.rho, Rseed, pp.noisePolarity);
elseif isequal(pp.noisechar, 1), % running noise
   maxLevel = initNoiseBuf(pp.lowFreq, pp.highFreq, 0, Rseed, pp.rho);
end

% update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
limlevel = updateMaxSPLinfo(maxLevel(1), maxLevel(end), NaN, pp.active);

% SPLs
% check SPLs
if any(max(SPL)>limlevel),
   UIerror('level(s) too high');% where is that max level
   errorSPL = max(max(SPL));
   if any(pp.endSPL==errorSPL), UItextColor(hh.EndSPLEdit, RED); end;
   if any(pp.startSPL==errorSPL), UItextColor(hh.StartSPLEdit, RED); end;
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global idfSeq SMS CALIB;
limchan = idfLimitChan(pp.active, SPL);
idfSeq = NSPLcreateIDF(pp.lowFreq, pp.highFreq, pp.noisechar, ...
   pp.startSPL, pp.stepSPL, pp.endSPL, pp.rho, pp.delay, ...
   pp.interval, pp.burstDur, pp.riseDur , pp.fallDur, ...
   pp.reps, pp.order,...
   pp.active, limchan,...
   maxLevel, Rseed, pp.noisePolarity);

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('Checking parameters...OK');
ReportPlayTime(idfSeq,Nspl);









