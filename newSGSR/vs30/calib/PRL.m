function y=PRL(kw,varargin);
% PRL - generic callback  for PRL dialog - vs 12 and up
global PRLMenuStatus CALIBstatus
persistent figh hh

if nargin==0,
   if isempty(gcbo),
      error('Keyword nor callback.');
   end
   kw = get(gcbo,'tag');
end

switch kw
case 'debug',
   keyboard; 
case 'init', % syntax: PRL init [return]
   PRLMenuStatus = []; CALIBstatus = []; % start from scratch
   hh = openUImenu('PRL', 'newPRLmenu'); % menu name is PRL, but fig file is called newPRLMenu
   figh = hh.Root;
   DeclareMenuDefaults('PRL', 'Root:position', '*Edit:string', ...
      '*DACchannelButton:string', '*DACchannelButton:userdata');
   localFixTooltips(hh); % tooltips of play panel buttons must reflect CAV/PRB context
   setstring(hh.FilenameEdit, ''); % reusing old filenames is not practical
   if nargin<2, 
      PRL('reset'); % reset colors, enable status of uicontrols
      repaintWait(hh.Root);  
      PRLMenuStatus.measured = []; % save memory by erasing calib data
   end  % only return when menu is closed
case {'PRLResetButton', 'reset'},
   localSetAcceptStatus(hh, 'reset'); % nothing measured, nothing accepted
   localSetStatus(hh, 'wait', 'CAV');
case 'CalibModeButton',
   localSetStatus(hh, 'wait', -1); % swap CAV/PRB choice
case 'PRLCancelButton',
   if isequal('wait', CALIBstatus.action), 
      delete(figh);
   end
case 'close',
   if isequal('wait', CALIBstatus.action), 
      SaveMenuDefaults('PRL', '', 1);
      delete(figh);
   end
case 'LeftStartButton',   % ----perform CAV calibration; the results are ...
   localGO(hh, 'CAV'); % ... stored in PRLMenuStatus.measured.CAV
case 'RightStartButton',   % ----perform PRB calibration; the results are ...
   localGO(hh, 'PRB'); % ... stored in PRLMenuStatus.measured.PRB
case 'LeftPlotButton', % --------------------plot most recent CAV data
   CDplot(PRLMenuStatus.measured.CAV);
case 'RightPlotButton', % --------------------plot most recent PRB data
   CDplot(PRLMenuStatus.measured.PRB);
case 'LeftAcceptButton', % ---------------Set accept flag for CAV data
   localAccept(hh, 'CAV');
case 'RightAcceptButton', % ---------------Set accept flag for PRB data
   localAccept(hh, 'PRB');
case 'PRLPlotButton', % ---------------combine CAV/PRB->PRL and plot PRL
   CDplot(localPRL);
case 'PRLAcceptButton', % ---------------combine CAV/PRB->PRL, save and quit
   if localAccept(hh, 'PRL'), PRL('close'); end
case {'LeftStopButton', 'RightStopButton'},  % ------interrupt ongoing calibration
   CALIBstatus.interrupt = 1; % localGo will handle this further
case 'FilenameButton',
   localGetFilename(hh,1);
end

%----locals----------------
function localGO(hh, CorP);
% perform calibration
global PRLMenuStatus CALIBstatus
if ~isequal('wait', CALIBstatus.action), return; end; % playing .. do not interrupt
% get parameters and check them
[cpOK, BWreg, Fhighest, highestBW, eh] = CalibParamCheck(hh); 
if ~cpOK, return; end;
CS = CalibStim(BWreg, Fhighest, highestBW);
DAchan = UIIntFromToggle(localhandle(CorP, 'DACchannelButton')); % 1|2 ~ L|R 
micSens = abs(UIdoubleFromStr(localhandle(CorP, 'SenseEdit'),1));
micGain = UIdoublefromStr(localhandle(CorP, 'GainEdit'));
if ~checkNanAndInf([micSens micGain]), return; end;
% enable/disable proper set of uicontrols during play
localSetStatus(hh, 'play', CorP); % enable/disable buttons
UIenable(eh,0); % disable cliabparam edits
SNh = localhandle(CorP, 'SNratioText'); % handle to S/N text control
setstring(SNh, '');
% -----now we're ready to play/record----
DefaultStartAtt = 40; % dB default start setting of attenuator
maxSPL = 100; % dB max SPL - unduly high levels might cause trembing etc
CD = doCalibration(CS, CorP, DAchan, DefaultStartAtt, micSens, micGain, maxSPL,[],SNh);
if ~isempty(CD), % succesfull measurement; store data
   PRLMenuStatus.measured = setfield(PRLMenuStatus.measured, CorP, CD); 
end;
localSetStatus(hh, 'wait', CorP); % enable/disable buttons
UIenable(eh,1); % ensable calibparam edits
%----------
function OK = localAccept(hh, CorPorPRL);
% accept buttons' callback
OK = 0;
global PRLMenuStatus
if ~isequal('PRL',CorPorPRL), % CAV or PRB
   localSetAcceptStatus(hh, CorPorPRL);
   localSetStatus(hh, 'wait'); % update uicontrols' enable/disable state
   UIinfo([CorPorPRL ' transfer function accepted']);
else, % PRLaccept: combine CAV&PRB to PRL, save all 3 trfs
   fn = localGetFilename(hh);
   if isempty(fn), return; end; %error already handled by localGetFilename
   PRLtrf = localPRL;
   try,
      cdwrite(PRLMenuStatus.measured.CAV, fn);
      cdwrite(PRLMenuStatus.measured.PRB, fn);
      cdwrite(PRLtrf, fn);
      OK = 1;
   catch
      mess = strvcat('Matlab error message:', lasterr);
      errordlg(mess,'Unexpected error while saving CAV/PRB/PRL data');
      return;
   end;
   [pp sfn] = fileparts(fn);
   AddToLog(['PRL measured: ' sfn]);
end
%---------------
function FN = localGetFilename(hh,browse);
if nargin<2, browse=0; end;
FN = '';
textcolors; 
if browse,
   [fn fp] = uiputfile([calibdir '\*.CAV;*.PRB;*.PRL'], ...
      'select filename for CAV/PRB/PRL data');
   if fn==0, return; end; % user cancelled
   fn = removeFileExtension([fp fn]);
else,
   fn = getstring(hh.FilenameEdit);
   set(hh.FilenameEdit,'foregroundcolor', BLACK);
   fn = RemoveFileExtension(fullFileName(fn, calibdir, ''));
end
[pp ff] = fileparts(fn);
mess = '';
% check filename
if isempty(ff), % nothing specified: recursive call with browse
   FN = localGetFilename(hh,1); return;
elseif ~isValidFilename(ff),
   mess = ['Invalid filename ''' fn ''''];
elseif ~isSamePath(calibdir, pp), 
   mess = strvcat('Invalid directory:',...
      ['''' pp ''''], ...
      'for CAV/PRB/PRL data.', ...
      'CAV/PRB/PRL files must be saved in the calibration directory:',...
      ['''' calibdir '''']);
elseif exist([fn '.cav'],'file') ...
      | exist([fn '.prb'],'file') ...
      | exist([fn '.prl'],'file'),
   mess = strvcat('Calibration files named:', ['''' fn '.*'''], ...
      'already exist.', ...
      'Choose a different filename',...
      'or delete existing calibration files ');
end
if ~isempty(mess), % display error and return emptyness
   if ~browse,
      set(hh.FilenameEdit,'foregroundcolor', RED);
      drawnow;
   end
   eh = errordlg(mess, 'Cannot write calibration data');
else, % update edit, return full filename w/o extension
   setstring(hh.FilenameEdit, ff);
   FN = fullfile(pp, ff);
end
%---------------
function localStop;
global CALIBstatus
CALIBstatus.interrupt = 1;
% the rest will be handled by the playing functions
%------
function localCAVorPRL(hh, cop);
global PRLMenuStatus
cav = isequal('CAV',cop);
enableUIgroup('Left',cav);
enableUIgroup('CAV',cav);
enableUIgroup('Right',~cav);
enableUIgroup('PRB',~cav);
setstring(hh.CalibModeButton, cop);
PRLMenuStatus.CorP = cop;
if isequal(cop, 'CAV'), AddToUImessStack(hh.LeftReportText);
else, AddToUImessStack(hh.RightReportText);
end
%-------------
function p = localPRL;
global CALIBstatus PRLMenuStatus
try,
    p = CDcompprl({PRLMenuStatus.measured.CAV, PRLMenuStatus.measured.PRB});
catch,
   eh = errordlg(strvcat('Error while computing PRL',...
      'from CAV and PRB', ...
      'MatLab error:',lasterr), ...
      'Error while computing PRL', 'modal');
   uiwait(eh);
end
%-------------
function localSetStatus(hh, st, CorP);
global CALIBstatus PRLMenuStatus
if nargin<3, CorP = PRLMenuStatus.CorP; % keep current CAV/PRB choice
elseif isequal(-1,CorP), % swap CAV/PRB choice
   if isequal('CAV', PRLMenuStatus.CorP), CorP='PRB';
   else, CorP = 'CAV'; end;
end;
localCAVorPRL(hh, CorP);
dataMeasured = ~isempty(getFieldorDef(PRLMenuStatus.measured,CorP,[]));
bothAccepted = ...
   ~isempty(getFieldorDef(PRLMenuStatus.accepted,'CAV',[])) ...
   & ~isempty(getFieldorDef(PRLMenuStatus.accepted,'PRB',[]));
if isequal('wait',st),
   UIenable(localhandle(CorP, 'StartButton'),1);
   UIenable(localhandle(CorP, 'StopButton'),0);
   UIenable(localhandle(CorP, 'AcceptButton'), dataMeasured);
   UIenable(localhandle(CorP, 'PlotButton'), dataMeasured);
   UIenable(hh.CalibModeButton, 1);
   UIenable(hh.PRLPlotButton, bothAccepted);
   UIenable(hh.PRLAcceptButton, bothAccepted);
   UIenable(hh.PRLResetButton, 1);
   UIenable(hh.PRLCancelButton, 1);
elseif isequal('play',st), % disable all except stop button
   UIenable(localhandle(CorP, 'StartButton'),0);
   UIenable(localhandle(CorP, 'StopButton'),1);
   UIenable(localhandle(CorP, 'AcceptButton'), 0);
   UIenable(localhandle(CorP, 'PlotButton'), 0);
   UIenable(hh.CalibModeButton, 0);
   UIenable(hh.PRLPlotButton, 0);
   UIenable(hh.PRLAcceptButton, 0);
   UIenable(hh.PRLResetButton, 0);
   UIenable(hh.PRLCancelButton, 0);
else,
end
CALIBstatus.action = st;
%----------
function h = localhandle(prefix, Tag);
% aux fnc to retrieve handles w/o cumbersome syntax
if isequal('CAV',upper(prefix)), prefix = 'Left'; end;
if isequal('PRB',upper(prefix)), prefix = 'Right'; end;
global PRLMenuStatus
hh = PRLMenuStatus.handles;
h = getfield(PRLMenuStatus.handles, [prefix Tag]);
%----------
function localFixTooltips(hh);
% fix tooltip strings; they have to reflect the CAV/PRB context of the play panels
% CAV
set(hh.LeftStartButton, 'TooltipString', 'Start measuring CAV trf');
set(hh.LeftStopButton, 'TooltipString', 'Interrupt play/record');
set(hh.LeftAcceptButton, 'TooltipString', 'Accept most recent CAV trf'); 
set(hh.LeftPlotButton, 'TooltipString', 'Plot most recent CAV trf');
% PRB
set(hh.RightStartButton, 'TooltipString', 'Start measuring PRB trf');
set(hh.RightStopButton, 'TooltipString', 'Interrupt play/record');
set(hh.RightAcceptButton, 'TooltipString', 'Accept most recent PRB trf'); 
set(hh.RightPlotButton, 'TooltipString', 'Plot most recent PRB trf');
% PRL
set(hh.PRLAcceptButton, 'TooltipString', ...
   'Accept most recent PRL trf, save CAV/PRB/PRL data and quit menu'); 
set(hh.FilenamePrompt, 'TooltipString', ...
   ['Give filename for calibration data. Do NOT specify a directory: ',...
      'CAV/PRB/PRL data must be saved in the standard calibration directory.']);
set([hh.LeftSNratioText hh.RightSNratioText] , 'TooltipString', ...
   ['Display of background noise level as S/N ratio. ',...
      'Values below 30 dB indicate excessive background noise.']); 
%-----------------------
function localSetAcceptStatus(hh, CorPorReset);
global PRLMenuStatus
% collect handels of calibparam edits
[dum dum dum dum eh] = CalibParamCheck(hh);
if ~isequal('reset', CorPorReset), % CAV or PRB accept button
   ah = localhandle(CorPorReset, 'AcceptButton');
   Bcolor = [0.1 0.5 0.2]; % make button text green
   PRLMenuStatus.accepted;
   UIenable(eh, 0); % calibparams may not be changed anymore
   % indicate that CAV or PRB has been accepted by setting flags
   PRLMenuStatus.accepted = setfield(PRLMenuStatus.accepted, CorPorReset, 1);
else, % reset both buttons
   ah = [hh.LeftAcceptButton hh.RightAcceptButton];
   Bcolor = [0 0 0]; % black button texts
   % erase all measured data and reset acceptance flags
   PRLMenuStatus.measured = [];
   PRLMenuStatus.accepted = [];
   UIenable(eh, 1); % calibparams may be changed again
end
set(ah, 'foregroundcolor', Bcolor);
