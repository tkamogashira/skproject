function OK = ICIcheck;

% Checks params for ICImenu and stores the stimulus info in
% globals idfSeq and SMS  (PDP11 and SGSR formats, resp)

global StimMenuStatus SGSR PRPstatus
textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles;
set(hh.LevelPrompt,'tooltipstring','Level of first click in SPL as if the click rate were 100 Hz. Pairs of numbers are interpreted as [left right]');
set(hh.Level2Prompt,'tooltipstring','Level of second click in SPL as if the click rate were 100 Hz. Pairs of numbers are interpreted as [left right]');
set(hh.MaxSPLinfo,'tooltipstring','Max click SPL for current click parameters.');
UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- click params
[clickOK, pp.polarity, pp.clickDur] = ClickParamCheck;
if ~clickOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL1, pp.active, pp.SPL2] = SPLandChannelCheck;
if ~splOK, return; end;
%--- ICI sweep 
pp.startICI = UIdoubleFromStr(hh.startICIEdit,1);
pp.stepICI = abs(UIdoubleFromStr(hh.stepICIEdit,1));
pp.endICI = UIdoubleFromStr(hh.endICIEdit,1);
%--- delays 
pp.delay1 = UIdoubleFromStr(hh.DelayEdit,1);
pp.delay2 = UIdoubleFromStr(hh.Delay2Edit,1);

% any non-numerical or oversized input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

% ICIs must be positive
if pp.startICI<=0, 
   UIerror('ICIs must be positive',hh.startICIEdit);
   return;
end
if pp.endICI<=0, 
   UIerror('ICIs must be positive',hh.endICIEdit);
   return;
end
% analyze sweep params
RelTol = 0.1; % relative deviation of 10 % is tolerated without warning
[ICIs, mess, newStartICI] = ...
   LogSweepChecker(pp.startICI, pp.stepICI, pp.endICI, 1, RelTol, 'start');
ICIs=ICIs(:,1); % linsweepchecker always returns Nx2 matrix
switch mess
case 'ZEROSTEP',
   mess = strvcat('zero step size','but unequal start- and',...
      'end ICI values');
   UIerror(mess, hh.stepICIEdit);
   return;
case 'BIGADJUST',
   mess = strvcat('non-integer # sweep steps',...
      'between start & end ICI values:',...
      'start ICI will be adjusted');
   if StimMenuWarn(mess, hh.startICIEdit), return; end;
   pp.startICI = newStartICI;
   setstring(hh.startICIEdit,num2str(1e-3*round(1e3*newStartICI)));
   UItextColor(hh.startICIEdit, BLACK);
case 'SMALLADJUST',
   pp.startICI = newStartICI;
   setstring(hh.startICIEdit,num2str(1e-3*round(1e3*newStartICI)));
end
StimMenuStatus.params = pp;
% get and report # subseqs
Nici = length(ICIs);
if ~ReportNsubSeq(Nici), return; end;

MaxICI = max(ICIs);
MinICI = min(ICIs);
burstDur = MaxICI + 1.1*(max(pp.delay1) + max(pp.delay2)) + 4e-3*pp.clickDur;
if (burstDur>pp.interval),
   mess = strvcat('Interval too short too realize',...
      'ICIs and ITDs');
   UIerror(mess, hh.IntervalEdit);
   return;
end
if any(MinICI<=1e-3*pp.clickDur),
   mess = strvcat('Clicks overlap;',...
      'increase minumum ICI',...
      'or decrease click duration.');
   UIerror(mess, [hh.ClickDurEdit hh.startICIEdit]);
   return;
end


% now start more sophisticated param checks

% generate click train to evaluate max SP
MaxLevels = NaN+zeros(1, channelCount(pp.active));
SingleClick = 0;
clickData = pulseTrain(SingleClick, burstDur,ChannelChar(pp.active), pp.clickDur, pp.polarity);
maxLevel = clickData.maxSPL;

% update maxSPLinfo (pp.active = 0|1|2 ~ B|L|R)
limlevel = updateMaxSPLinfo(maxLevel(1), maxLevel(end), NaN, pp.active);

% SPLs
if any(pp.SPL1>[limlevel(1) limlevel(2)]),
   UIerror('level(s) too high', hh.LevelEdit);
   return;
end;
if any(pp.SPL2>[limlevel(1) limlevel(2)]),
   UIerror('level(s) too high', hh.Level2Edit);
   return;
end;

% if we got here, params are OK
% put params in global idfSeq (PDP11 format) and ...
% ... convert to SMS stimulus specification (SGSR format)
global idfSeq SMS CALIB;
limchan = idfLimitChan(pp.active,[1 1]);
idfSeq = ICIcreateIDF(pp.SPL1, pp.SPL2, ...
   pp.startICI, pp.stepICI, pp.endICI, ...
   pp.interval, pp.clickDur, pp.polarity,...
   pp.delay1, pp.delay2,...
   pp.reps, pp.order,...
   pp.active, limchan);

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);








