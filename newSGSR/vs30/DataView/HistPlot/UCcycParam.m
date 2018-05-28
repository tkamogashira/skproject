function UCcycParam(keyword, varargin);
% UCCYCPARAM - parameter dialog of UCCYC



% use generic UCxxxParam script to handle generic stuff
callerfnc = mfilename; 
DialogName = 'CYCparam';
UCxxxParamSwitchboard; 


%========specific stuff is handles by local functions below===============


%================================================================
function localFillEdits(hh, Param);
% params are passed as struct; display them in appropriate edits
% without strict testing. This fcn should always be synchronized
% with UCcyc (it may be better to merge these two)
if nargin<2, Param = []; end;
% ---standard edits: Nbin Isub, timeWindow, Yunit, Ymax
[ds, hh, Param] = DataPlotFillEdits(hh, Param, 'CYC');
% ---wrap frequency for cycle histogram
% evaluate possible combinations of freq (car|mod|other) and ...
%  ... channel (beat|left|right|none) for current dataset
[ifc icc fstr cstr defaultstr] = exploreFcycle(ds);
% initialize buttons accordingly
hfcyc = [hh.FcycButton, hh.ChanButton];
cycEdith = [hh.FcycEdit hh.FcycUnit]; % uicontrols whose vivibilty depend on button 
UItwobuttons('init',hfcyc, ifc, icc, fstr, cstr, {cycEdith nan}, {[1 0 0 0] nan});
if isequal('auto', Param.FcycType),
   % set buttons to default settings obtained from exploreFcycle
   UItwobuttons('set', hfcyc, defaultstr{:});
else, % reproduce settings from last visit - do it in a foolproof way, though
   try,   
      UItwobuttons('set', hfcyc, Param.FcycType, Param.Chan);
      setstring(hh.FcycEdit, num2str(Param.Fcyc));
   catch, UItwobuttons('set', hfcyc, defaultstr{:});
   end
end

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
% Fcycle
FcycType = getstring(hh.FcycButton);
Chan = getstring(hh.ChanButton);
visi = get(hh.FcycEdit, 'visible');
if isequal('on', visi), 
   Fcyc = UIdoubleFromStr(hh.FcycEdit,1);
else, Fcyc = 100;
end
param = collectInStruct(iSub, iRep, Ymax, Yunit, Nbin, TimeWindow, FcycType, Chan, Fcyc);

