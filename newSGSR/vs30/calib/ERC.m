function ERCfile=ERC(kw,varargin);
% ERC - generic callback  for ERC dialog - vs 12 and up
global ERCMenuStatus CALIBstatus
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
case 'ERCFilenameButton',
   FN = localgetERCname(hh, 1);
case 'init', % syntax: ERC init DAactive ERCfilename [return]
   LeftDACear = '';
   while isempty(LeftDACear), 
      LeftDACear = ...
         questdlg('Which ear is listening to the DAC output 0 (=RED) ?', ...
         'By way of orientation..', 'LEFT EAR', 'RIGHT EAR', '');
   end
   ERCMenuStatus = []; CALIBstatus = []; % start from scratch
   ERCMenuStatus.DAactive = channelChar(varargin{1}, 1); % Both|Left|Right
   ERCMenuStatus.LeftDACear = LeftDACear(1);
   hh = openUImenu('ERC', 'newERCmenu'); % menu name is ERC, but fig file is called newERCMenu
   noCloseDLG(hh.Root, strvcat('To close the ERC dialog, you must', ...
      'hit either Save&Close or Cancel.'), 'OK or Cancel?');
   figh = hh.Root;
   DeclareMenuDefaults('ERC', 'Root:position', '*Edit:string', ...
      '*DACchannelButton:string', '*DACchannelButton:userdata');
   localFixTooltipsEtc(hh); % tooltips of play panel buttons must reflect CAV/PRB context
   if nargin>2, % we assume it is a valid filename and block any editing of it
      fne = hh.ERCFilenameEdit; fnb = hh.ERCFilenameButton;
      setstring(fne, varargin{2});
      UIenable([fne fnb], 0);
   end
   ERCMenuStatus.ERCfile = ''; % nothing saved yet
   localSetAcceptStatus(hh, 'reset'); % nothing measured, nothing accepted
   localSetStatus(hh, 'wait'); % nothing played, enable/disable <-active DAC
   if nargin<4, 
      repaintWait(hh.Root);  
      ERCMenuStatus.measured = []; % save memory by erasing calib data
      ERCfile = ERCMenuStatus.ERCfile;
   end  % only return when menu is closed
case 'CalibModeButton',
   localSetStatus(hh, 'wait', -1); % swap CAV/PRB choice
case 'CancelButton',
   if isequal('wait', CALIBstatus.action), 
      delete(figh);
   end
case 'close',
   if isequal('wait', CALIBstatus.action), 
      SaveMenuDefaults('ERC', '', 1);
      delete(figh);
   end
case 'LeftStartButton',   % ----perform left-ear calibration; the results are ...
   localGO(hh, 'Left'); % ... stored in ERCMenuStatus.measured.Left
case 'RightStartButton',   % ----perform right-ear calibration; the results are ...
   localGO(hh, 'Right'); % ... stored in ERCMenuStatus.measured.Right
case 'LeftPlotButton', % --------------------plot most recent left-ear data
   CDplot(ERCMenuStatus.measured.Left);
case 'RightPlotButton', % --------------------plot most recent right-ear data
   CDplot(ERCMenuStatus.measured.Right);
case 'LeftAcceptButton', % ---------------Set accept flag for left-ear data
   localAccept(hh, 'Left');
case 'RightAcceptButton', % ---------------Set accept flag for right-ear data
   localAccept(hh, 'Right');
case 'LeftPRLFilenameButton', % ----------browse for left-ear PRL
   localgetPRL(hh, 'Left', 1);
case 'RightPRLFilenameButton', % ----------browse for left-ear PRL
   localgetPRL(hh, 'Right', 1);
case 'SaveQuitButton', % ---------------combine CAV/PRB->PRL, save and quit
   if localSaveAndQuit(hh), ERC('close'); end
case {'LeftStopButton', 'RightStopButton'},  % ------interrupt ongoing calibration
   CALIBstatus.interrupt = 1; % localGo will handle this further
end
%----locals----------------
function localGO(hh, chan);
% perform calibration
global ERCMenuStatus CALIBstatus
if ~isequal('wait', CALIBstatus.action), return; end; % playing .. do not interrupt
% get parameters and check them
localDirectMessages(hh,chan); % direct UI messages to correct side of menu
[cpOK, BWreg, Fhighest, highestBW, eh, maxSPL] = CalibParamCheck(hh);
CS = CalibStim(BWreg, Fhighest, highestBW);
if ~cpOK, return; end;
micSens = abs(UIdoubleFromStr(localhandle(chan, 'SenseEdit'),1));
micGain = UIdoublefromStr(localhandle(chan, 'GainEdit'));
if ~checkNanAndInf([micSens micGain]), return; end;
% PRL functions
Prl = localgetPRL(hh, chan);
if isempty(Prl), 
   return; % errors handled by localgetPRL
elseif isequal('none', Prl), Prl = []; % s[ecial nonsense value to indicate no PRL
end; 
% enable/disable proper set of uicontrols during play
localSetStatus(hh, 'play', chan); % enable/disable buttons
UIenable(eh,0); % disable calibparam edits
SNh = localhandle(chan, 'SNratioText'); % handle to S/N text control
setstring(SNh, '');
% -----now we're ready to play/record----
DefaultStartAtt = 150-maxSPL; % dB default start setting of attenuator
DefaultStartAtt = clip(DefaultStartAtt, 0, maxAnalogAtten);
CD = doCalibration(CS, 'ERC', chan, DefaultStartAtt, micSens, micGain, maxSPL, Prl, SNh);
if ~isempty(CD), % succesfull measurement; store data
   ERCMenuStatus.measured = setfield(ERCMenuStatus.measured, chan, CD); 
end;
localSetStatus(hh, 'wait'); % enable/disable buttons
UIenable(eh,1); % enable calibparam edits
%----------
function OK = localAccept(hh, chan);
% accept buttons' callback
OK = 0;
global ERCMenuStatus
localSetAcceptStatus(hh, chan);
localSetStatus(hh, 'wait'); % update uicontrols' enable/disable state
UIinfo([chan '-ear ERC function accepted']);
%----------
function OK = localSaveAndQuit(hh);
global ERCMenuStatus
OK = 0;
filename = localgetERCname(hh);
if isempty(filename), return; end;
try,
   FNS = fieldnames(ERCMenuStatus.measured);
   if isempty(FNS), error('No ERC measured?!'); end;
   for ii=1:length(FNS), 
      trf = getfield(ERCMenuStatus.measured, FNS{ii});
      trf.LeftDACear = ERCMenuStatus.LeftDACear;
      cdwrite(trf, filename);
   end
   OK = 1;
catch,
   mess = strvcat('Matlab error message:', lasterr);
   errordlg(mess,'Unexpected error while saving ERC data');
end;
ERCMenuStatus.ERCfile = filename;
%------
function p = localgetPRL(hh, chan, browse);
global CALIBstatus ERCMenuStatus
if nargin<3, browse=0; end;
p = [];
edh = getfield(hh,[chan 'PRLFilenameEdit']);
if browse, 
   tit = ['Select ' lower(chan) '-channel PRL' ];
   p = CDread('PRL', '', nan, tit);
   if isempty(p), return; end;
   [pp fn ee] = fileparts(p.filename);
else,
   fn = trimspace(getstring(edh));
   if isequal('none',lower(fn)),
      p = 'none'; % special value indicating that no PRL correction is preferred
      return;
   elseif isempty(fn),  % recursive call w browse
      p = localgetPRL(hh, chan, 1); 
      return;
   end;
   [pp fn ee] = fileparts(fn);
   try, p = CDread('PRL', fn); 
   catch, 
      eh = errordlg(strvcat('Matlab error:', lasterr), ...
         'Error retrieving PRL data');
      return;
   end
end
if ~isfield(p, 'CalType'),
   eh = errordlg(strvcat('Obsolete PRL data.',...
      'PRL data obtained under SGSR vs1.x',...
      'are not compatible with version 2 and up.',...
      'New PRL calibration data need to be measured.'), ...
      'Version conflict.', 'modal');
   p = [];
   return;
end
setstring(edh, fn);
%-------------
function FN = localgetERCname(hh, browse);
global CALIBstatus ERCMenuStatus
FN = '';
if nargin<2, browse=0; end;
p = [];
edh = hh.ERCFilenameEdit;
buh = hh.ERCFilenameButton;
if browse, 
   tit = ['Select ERC filename' ];
   [fn fp] = uiputfile([datadir '\*.ERC'], 'Specify ERC filename to write');
   if fn==0, return; end; % user cancelled
   FN = fullfilename(fn, datadir, 'ERC');
else,
   fn = trimspace(getstring(edh));
   if isempty(fn), 
      FN = localgetERCname(hh, 1);
      return
   end
   FN = fullfilename(fn, datadir, 'ERC');
end
[pp ff ee] = fileparts(FN);
mess = '';
if exist(FN,'file'),
   mess = strvcat('ERC file:', FN, 'already exists.',...
      'Delete this file or choose new ERC filename.' );
elseif ~isvalidFilename(ff),
   mess = strvcat('invalid filename:', ff);
elseif ~issamePath(datadir,pp),
   mess = strvcat('wrong directory:', pp, ...
      'ERC files must be in data directory:', datadir);
end
if ~isempty(mess),
   UIenable([edh buh]); % enable user to fix the problems  
   eh = errordlg(mess, 'Error writing ERC data');
   FN = '';
else, setstring(edh, fn);
end
%-------------
function localSetStatus(hh, st, LR);
global CALIBstatus ERCMenuStatus
if nargin<3, LR = ERCMenuStatus.DAactive; end;
LeftAccepted = ~isempty(getFieldorDef(ERCMenuStatus.accepted,'Left',[]));
RightAccepted = ~isempty(getFieldorDef(ERCMenuStatus.accepted,'Right',[]));
if isequal('wait',st),
   if isequal('Right',LR), 
      EnableUIgroup('Left',0,hh.Root);
      UIenable(hh.SaveQuitButton, RightAccepted);
   else,
      EnableUIgroup('Left',1,hh.Root);
      dataMeasured = ~isempty(getFieldorDef(ERCMenuStatus.measured,'Left',[]));
      UIenable(hh.LeftStartButton,1);
      UIenable(hh.LeftStopButton,0);
      UIenable(hh.LeftPlotButton,dataMeasured);
      UIenable(hh.LeftAcceptButton,dataMeasured);
   end
   if isequal('Left',LR), 
      EnableUIgroup('Right',0,hh.Root);
      UIenable(hh.SaveQuitButton, LeftAccepted);
   else,
      EnableUIgroup('Right',1,hh.Root);
      dataMeasured = ~isempty(getFieldorDef(ERCMenuStatus.measured,'Right',[]));
      UIenable(hh.RightStartButton,1);
      UIenable(hh.RightStopButton,0);
      UIenable(hh.RightPlotButton,dataMeasured);
      UIenable(hh.RightAcceptButton,dataMeasured);
   end
   if isequal('Both',LR), 
      UIenable(hh.SaveQuitButton, LeftAccepted & RightAccepted);
   end
   UIenable(hh.CancelButton, 1);
elseif isequal('play',st), % disable all except stop button
   UIenable(hh.CancelButton, 0);
   UIenable(hh.SaveQuitButton, 0);
   EnableUIgroup('Left',0,hh.Root);
   EnableUIgroup('Right',0,hh.Root);
   UIenable(getfield(hh,[LR 'StopButton']),1);
   localDirectMessages(hh,LR); % enable messages
else,
end
CALIBstatus.action = st;
%----------
function h = localhandle(prefix, Tag);
% aux fnc to retrieve handles w/o cumbersome syntax; prefix=Left|Right|Both
global ERCMenuStatus
h = [];
if ~isequal('Right',prefix),
   h = [h getfield(ERCMenuStatus.handles, ['Left' Tag])];
end
if ~isequal('Left',prefix),
   h = [h getfield(ERCMenuStatus.handles, ['Right' Tag])];
end

%----------
function localDirectMessages(hh,chan);
rh = getfield(hh, [chan 'ReportText']); % handle of report text
AddToUImessStack(rh); % this implicitly makes the text control active
snh = getfield(hh, [chan 'SNratioText']); % handle S/N ratio text
UIenable(snh);
%----------
function localFixTooltipsEtc(hh);
% fix tooltip strings; they have to reflect the ERC context of the play panels
set(hh.LeftStartButton, 'TooltipString', 'Start measuring left-ear trf');
set(hh.LeftStopButton, 'TooltipString', 'Interrupt play/record');
set(hh.LeftAcceptButton, 'TooltipString', 'Accept most recent left-ear trf'); 
set(hh.LeftPlotButton, 'TooltipString', 'Plot most recent left-ear trf');
% Right
set(hh.RightStartButton, 'TooltipString', 'Start measuring right-ear trf');
set(hh.RightStopButton, 'TooltipString', 'Interrupt play/record');
set(hh.RightAcceptButton, 'TooltipString', 'Accept most recent right-ear trf'); 
set(hh.RightPlotButton, 'TooltipString', 'Plot most recent right-ear trf');
% PRL
set([hh.LeftSNratioText hh.RightSNratioText] , 'TooltipString', ...
   ['Display of background noise level as S/N ratio. ',...
      'Values below 30 dB indicate excessive background noise.']); 
% Callbacks of buttons should be 'ERC'
FNS = fieldnames(hh);
for ii=1:length(FNS), h = getfield(hh, FNS{ii});
   try, % change callback if any
      cb = lower(get(h, 'callback'));
      if isequal('prl',cb(1:3)), set(h,'callback', 'ERC;'); end; 
   end;
end

%-----------------------
function localSetAcceptStatus(hh, LR);
global ERCMenuStatus
DAC = ERCMenuStatus.DAactive;
if ~isequal('reset', LR), % Left or Right accept button
   ah = localhandle(LR, 'AcceptButton');
   Bcolor = [0.1 0.5 0.2]; % make button text green
   % indicate that Left or Right has been accepted by setting flags
   ERCMenuStatus.accepted = setfield(ERCMenuStatus.accepted, LR, 1);
else, % reset both buttons
   ah = [hh.LeftAcceptButton hh.RightAcceptButton];
   Bcolor = [0 0 0]; % black button texts
   % erase all measured data and reset acceptance flags
   ERCMenuStatus.measured = [];
   ERCMenuStatus.accepted = [];
end
set(ah, 'foregroundcolor', Bcolor);
