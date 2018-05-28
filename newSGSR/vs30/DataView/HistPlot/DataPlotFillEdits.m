function [ds, hh, Param] = DataPlotFillEdits(hh, Param, Caller);
% DataPlotFillEdits - fill standard edits of param dialog: Nbin Isub, timeWindow, Yunit, Ymax


% get info from param dialog
if ~isstruct(hh), hh = getUIhandle(hh); end;

if isempty(Param), Param = getUIprop(hh.Root, 'Iam.params'); end;
ds = getUIprop(hh.Root, 'Iam.ds');
Nsub = ds.nsub;

Level = getUIprop(hh.Root, 'Iam.Level');
defa = isequal('Defaults', Level); % default value setting?


% check presence of certain default uicontrols
doSub = isfield(hh,'IsubUnit'); % presence of sub choice
doRep = isfield(hh,'RepSelectEdit'); % presence of rep choice
doBin = isfield(hh,'NbinEdit'); % presence of nbin choice
doY = isfield(hh,'YmaxEdit'); % presence of Ymax & Y-units stuff


% display info on dialog
if defa,
   set(hh.Root,'name', ['Parameter default values for ' Caller ]);
   set(hh.OKButton, 'tooltip', ['Accept current values as default parameters for ' Caller ' analysis.' ])
   set(hh.ApplyButton, 'tooltip', ['Apply current values to analysis plot but do not accept them as defaults.' ])
   set(hh.DefaultButton, 'string', ['Factory' ])
else,
   set(hh.Root,'name', [Caller ' parameters for ' ds.title]);
   if doSub,
      setstring(hh.IsubUnit, ['(1..' num2str(Nsub) ')']); % indicate maximum #subs
   end
end

% do some conversion 
TW = Param.TimeWindow;
if ischar(TW), TWstr = TW; % default values like 'repdur'
else, TWstr = num2sstr(TW);
end
if (length(TW))==2 & (TW(1)==0), TW = TW(2); end % simplify [0 X] -> X

if doY,
   if ischar(Param.Ymax), YmaxStr = Param.Ymax; else, YmaxStr = num2sstr(Param.Ymax); end; 
   if isequal('Spikes', Param.Yunit), Ybval = 1; else, Ybval=2; end;
end

if doSub,
   isubstr = Param.iSub;
   if isnumeric(isubstr), isubstr = num2sstr(isubstr,1); end; % smart mode of num2sstr
end

if doRep,
   irepstr = Param.iRep;
   if isnumeric(irepstr), irepstr = num2sstr(irepstr,1); end; % smart mode of num2sstr
end

% set button, fill edits
if doY,
   setstring(hh.YmaxEdit, YmaxStr);
   if isfield(hh,'YunitButton'),
      set(hh.YunitButton, 'userdata', Ybval); menubuttonmatch(hh.YunitButton);
   end
end
if doSub, setstring(hh.IsubEdit, isubstr); end;
if doRep, setstring(hh.RepSelectEdit, irepstr); end;
setstring(hh.TimeWindowEdit, TWstr);
if doBin, setstring(hh.NbinEdit,       num2sstr(Param.Nbin)); end;

