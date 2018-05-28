function UClatParam(keyword, varargin);
% UClatPARAM - parameter dialog of UClat


% use generic UCxxxParam script to handle generic stuff
callerfnc = mfilename; 
DialogName = 'LATparam';
UCxxxParamSwitchboard; 

%========specific stuff is handles by local functions below===============

%================================================================
function localFillEdits(hh, Param);
% params are passed as struct; display them in appropriate edits
% without strict testing. This fcn should always be synchronized
% with UClat (it may be better to merge these two)
if nargin<2, Param = []; end;
% ---standard edits: Nbin Isub, timeWindow, Yunit, Ymax
[ds, hh, Param] = DataPlotFillEdits(hh, Param, 'LAT');

function param = localReadEdits(hh);
if ~isstruct(hh), hh = getUIhandle(hh); end;
Nsub = getUIprop(hh.Root, 'Iam.ds.Nsub');
Nrep = getUIprop(hh.Root, 'Iam.ds.Nrep');
UIinfo(''); % clear message window
param = [];
Yunit = getstring(hh.YunitButton);
[iSub, Nbin, iRep] = IsubAndNbinCheck(hh, Nsub, Nrep);
if isempty(iSub), return; end;
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
param = collectInStruct(iSub, iRep, Ymax, Yunit, Nbin, TimeWindow);

