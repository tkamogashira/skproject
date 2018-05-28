function OK = CSPLcheck;

% CSPLcheck
% Checks params for CSPLmenu and stores the stimulus info in
% globals idfSeq and SMS  (PDP11 and SGSR formats, resp)

global StimMenuStatus SGSR PRPstatus clickData
textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles; 
hfreq = hh.CarFreqPrompt;
setstring(hfreq,'click rate:')
set(hfreq,'tooltipstring','Click rate in Hz. Zero rate: single click. Pairs of numbers are interpreted as [left right]');
UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- duration params
[durOK, pp.burstDur, pp.riseDur, pp.fallDur pp.delay] = DurationsCheck(0,1); % dual dur values allowed; no gating
if ~durOK, return; end;
%--- click params
[clickOK, pp.polarity, pp.clickDur] = ClickParamCheck;
if ~clickOK, return; end;
%--- SPL-sweep params 
pp.freq = abs(UIdoubleFromStr(hh.CarFreqEdit,2));
pp.startSPL = UIdoubleFromStr(hh.StartSPLEdit,2);
pp.stepSPL = abs(UIdoubleFromStr(hh.StepSPLEdit,2));
pp.endSPL = UIdoubleFromStr(hh.EndSPLEdit,2);
[pp.active, acOK] = activeChanCheck;
if ~acOK, return; end

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
noiseDur = max(1.1*abs(pp.delay))+ max(pp.burstDur);
if (noiseDur>pp.interval),
   mess = strvcat('interval too small to realize bursts',...
      'and interaural delays');
   UIerror(mess, hh.IntervalEdit);
   return;
end;
if any(pp.clickDur*1e-6.*pp.freq>0.99),
   mess = strvcat('Combination of click rate and','click duration leads to', 'overlapping pulses.');
   UIerror(mess, [hh.ClickDurEdit hh.CarFreqEdit]);
   return;
end

% generate click train to evaluate max SP
MaxLevels = NaN+zeros(1, channelCount(pp.active));
clickData = pulseTrain(pp.freq, pp.burstDur,ChannelChar(pp.active), pp.clickDur, pp.polarity);
maxLevel = clickData.maxSPL;

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
idfSeq = CSPLcreateIDF(pp.freq, pp.clickDur, pp.polarity, ...
   pp.startSPL, pp.stepSPL, pp.endSPL, pp.delay, ...
   pp.interval, pp.burstDur, ...
   pp.reps, pp.order,...
   pp.active, limchan,...
   maxLevel);

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK',-1)
