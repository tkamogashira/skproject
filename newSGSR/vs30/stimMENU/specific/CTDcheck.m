function [OK, varargout] = CTDcheck(varargin);
if nargin>0, % query of local function
   OK = 1; varargout = cell(1,nargout-1);
   [varargout{:}] = feval(varargin{:});
   return;
end
% Checks params for NTDmenu and stores the stimulus info in
% globals idfSeq and SMS  (PDP11 and SGSR formats, resp)

global StimMenuStatus SGSR PRPstatus clickData
textcolors;

OK = 0; StimMenuStatus.paramsOK = 0;

hh = StimMenuStatus.handles;
set(hh.LevelPrompt,'tooltipstring','Level of click in SPL as if the click rate were 100 Hz. Pairs of numbers are interpreted as [left right]');
set(hh.MaxSPLinfo,'tooltipstring','Max click SPL for current click parameters.');
UIinfo('Checking parameters...');

% collect param values from uicontrols
pp = []; pp.dummy=''; % pp must be struct before other fields can be filled
%--- presentation params
[presOK, pp.reps, pp.interval, pp.order] = presentationCheck;
if ~presOK, return; end;
%--- SPLs and active channels
[splOK, pp.SPL, pp.active] = SPLandChannelCheck;
if ~splOK, return; end;
%--- click params
[clickOK, pp.polarity, pp.clickDur] = ClickParamCheck;
if ~clickOK, return; end;
%--- NTD sweep 
pp.startITD = UIdoubleFromStr(hh.startITDEdit,1);
pp.stepITD = abs(UIdoubleFromStr(hh.stepITDEdit,1));
pp.endITD = UIdoubleFromStr(hh.endITDEdit,1);

% any non-numerical or oversized input that hasn't been caught yet?
if ~CheckNaNandInf(pp), return; end;

% analyze sweep params (delegated to function to allow external calls)
[ITDs, mess, newStartITD] = local_ITD(pp.startITD, pp.stepITD, pp.endITD);
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

% generate click train to evaluate max SP
MaxLevels = NaN+zeros(1, channelCount(pp.active));
SingleClick = 0;
burstDur = 2e-3*pp.clickDur;
clickData = pulseTrain(SingleClick, burstDur,ChannelChar(pp.active), pp.clickDur, pp.polarity);
maxLevel = clickData.maxSPL;

% durations
if any(abs(pp.polarity)*burstDur>pp.interval), % double the duration for biphasic pulses
   mess = strvcat('interval too small to realize clicks');
   UIerror(mess, hh.IntervalEdit);
   return;
end;

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
limchan = idfLimitChan(pp.active,[1 1]);
idfSeq = CTDcreateIDF(pp.SPL, ...
   pp.startITD, pp.stepITD, pp.endITD, ...
   pp.interval, pp.clickDur, pp.polarity,...
   pp.reps, pp.order,...
   pp.active, limchan);

SMS = IDF2SMS(idfSeq, CALIB.ERCfile);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;
UIinfo('OK', -1);
ReportPlayTime(idfSeq,Nitd);

%-----------------------------------------
function [ITDs, mess, newStartITD] = local_ITD(startITD, stepITD, endITD);
AbsTol = 0.01; % absolute deviation of 10 us is tolerated without warning
[ITDs, mess, newStartITD] = ...
   LinSweepChecker(startITD, stepITD, endITD, 1,...
   AbsTol, 'start');
ITDs=ITDs(:,1); % linsweepchecker always returns Nx2 matrix







