function UCrateParam(keyword, varargin);
% UCRATEPARAM - parameter dialog of UCRATE


% use generic UCxxxParam script to handle generic stuff
callerfnc = mfilename; 
DialogName = 'RATEparam';
UCxxxParamSwitchboard; 

%========specific stuff is handles by local functions below===============

function localFillEdits(hh, Param);
% params are passed as struct; display them in appropriate edits
% without strict testing. This fcn should always be synchronized
% with UCrate (it may be better to merge these two)
if nargin<2, Param = []; end;
% ---standard edits: Nbin Isub, timeWindow, Yunit, Ymax
[ds, hh, Param] = DataPlotFillEdits(hh, Param, 'RAT');

function param = localReadEdits(hh);
if ~isstruct(hh), hh = getUIhandle(hh); end;
Nrep = getUIprop(hh.Root, 'Iam.ds.Nrep');
[dum, dum2, iRep] = IsubAndNbinCheck(hh, nan, Nrep);
UIinfo(''); % clear message window
param = [];
Yunit = getstring(hh.YunitButton);
% Ymax
set(hh.YmaxEdit, 'foregroundcolor', [0 0 0]);
Ymax = getstring(hh.YmaxEdit); 
sterr = strvcat('Ymax must be a positive number', ' or the word "auto"');
if ~isequal('auto', Ymax),
   Ymax = UIdoubleFromStr(hh.YmaxEdit,1);
   if isnan(Ymax), UIerror(sterr, hh.YmaxEdit); return;
   elseif ~CheckNaNandInf(Ymax), return;
   elseif Ymax<=0, UIerror(sterr); return
   end
end
TimeWindow = TimeWindowCheck(hh);
if isempty(TimeWindow), return; end;
param = collectInStruct(iRep, Ymax, Yunit, TimeWindow);

