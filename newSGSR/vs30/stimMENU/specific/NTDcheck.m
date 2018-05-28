function OK = NTDcheck;

% Checks params for NTDmenu and stores the stimulus info in
% globals idfSeq and SMS  (PDP11 and SGSR formats, resp)
% SGSR version 07 & higher
% note: PRPstatus must be initialized at entry

global StimMenuStatus SGSR PRPstatus
hh = StimMenuStatus.handles;

persistent Rseed
if isempty(Rseed), % initial call to NTDcheck -> initialize Rseed
   Rseed = SetRandState; % this way, the max SPL values will
   % .. not fluctuate from try to try
end

%-------Remove next two lines to remove Rseed hack-------
if inLeuven | inUtrecht,
   %disp('warning: using fixed random seed');
   %Rseed = 12345; % HACK for JOELLE exp 
else,
   set(hh.RseedEdit,'visible', 'off');
   setstring(hh.RseedEdit, num2str(Rseed)); % will be read back
   set(hh.RseedPrompt,'visible', 'off');
end
%--------------------------------------------------------


textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur] = DurationsCheck(1); % single dur values
if ~durOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;
%--- generic noise parameters
[fbOK, pp.lowFreq, pp.highFreq, pp.rho, pp.noisechar] = NoiseParamChecker;
pp.Rseed = UIdoubleFromStr(hh.RseedEdit,1);
if ~fbOK, return; end;
%--- NTD sweep 
pp.startITD = UIdoubleFromStr(hh.startITDEdit,1);
pp.stepITD = abs(UIdoubleFromStr(hh.stepITDEdit,1));
pp.endITD = UIdoubleFromStr(hh.endITDEdit,1);

% any non-numerical or oversized input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

% analyze sweep params
AbsTol = 0.01; % absolute deviation of 10 us is tolerated without warning
[ITDs, mess, newStartITD] = ...
   LinSweepChecker(pp.startITD, pp.stepITD, pp.endITD, 1,...
   AbsTol, 'start');
ITDs=ITDs(:,1); % linsweepchecker always returns Nx2 matrix
switch mess
case 'ZEROSTEP',
   mess = strvcat('zero step size','but unequal start- and',...
      'end ITD values');
   UIerror(mess, hh.stepITDEdit);
   return;
case 'BIGADJUST',
   mess = strvcat('non-integer # sweep steps',...
      'between start & end ITD values:',...
      'start ITD will be adjusted');
   if StimMenuWarn(mess, hh.startITDEdit), return; end;
   pp.startITD = newStartITD;
   setstring(hh.startITDEdit,num2str(1e-3*round(1e3*newStartITD)));
   UItextColor(hh.startITDEdit, BLACK);
case 'SMALLADJUST',
   pp.startITD = newStartITD;
   setstring(hh.startITDEdit,num2str(1e-3*round(1e3*newStartITD)));
end
StimMenuStatus.params = pp;
% get and report # subseqs
Nitd = length(ITDs);
if ~ReportNsubSeq(Nitd), return; end;

% now start more sophisticated param checks
% interval / duration
noiseDur = max(abs(ITDs))+pp.burstDur;
if (noiseDur>pp.interval),
   mess = strvcat('interval too small to realize bursts',...
      'and interaural delays');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

% initialize noise buffer to get maximum SPL. Distinguish frozen & running noise
if isequal(pp.noisechar, 0), % frozen noise
   [dummy maxLevel] = gaussNoiseBand(pp.lowFreq, pp.highFreq, ...
   noiseDur, 0, pp.active, pp.rho, pp.Rseed);
elseif isequal(pp.noisechar, 1), % running noise
   maxLevel = initNoiseBuf(pp.lowFreq, pp.highFreq, 0, pp.Rseed, pp.rho);
end

% update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
limlevel = updateMaxSPLinfo(maxLevel(1), maxLevel(end), NaN, pp.active);

% SPLs
if any(pp.SPL>[limlevel(1) limlevel(2)]),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global idfSeq SMS CALIB;
limchan = idfLimitChan(pp.active,[0 0 ;1 2]); % default: right channel is varied
idfSeq = NTDcreateIDF(pp.lowFreq, pp.highFreq, pp.noisechar, pp.SPL, ...
   pp.startITD, pp.stepITD, pp.endITD, pp.rho, ...
   pp.interval, pp.burstDur, pp.riseDur , pp.fallDur, ...
   pp.reps, pp.order,...
   pp.active, limchan, ...
   maxLevel, pp.Rseed);

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);
ReportPlayTime(idfSeq,Nitd);








