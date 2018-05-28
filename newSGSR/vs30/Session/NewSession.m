function NewSession(keyword, varargin);
% NewSession - generic callback fnc for NewSession menu

persistent hh;

if nargin<1, % get keyword from callback object' tag
   keyword = get(gco,'tag');
end
MenuName = 'NewSession';


switch lower(keyword),
case 'debug',
   keyboard;
case 'init', % open the NewSession window
   hh = openuimenu(MenuName,'','modal');
   DeclareMenuDefaults(MenuName,...
      'Root:position', ...
      '*Edit:String', ...
      '*Button:String',...
      '*Button:Userdata');
   if nargin>1, return; end; % do not wait
   if ~InLeuven % & ~inUtrecht,
      set(hh.requestIDButton, 'visible', 'off');
      set(hh.requestIDPrompt, 'visible', 'off');
      set(hh.ExperimentorPrompt, 'visible', 'off');
      set(hh.ExperimentorEdit, 'visible', 'off');
   end
   setstring(hh.ExperimentorEdit, '');
   repaintwait(hh.Root); % wait for window to be deleted; 
   % clear global NewSessionMenuStatus
case {'close','cancelbutton'},
   delete(gcbf);
case {'okbutton'},
   if ~local_InitSession(varargin{:}), return; end;
   saveMenuDefaults(MenuName);
   delete(gcbf);
case {'nomenu'},
   if ~local_InitSession(varargin{:},1), return; end;
case 'datafilebutton',
   [fn fp]=uiputfile([datadir '\*.spk; *.idf; *.sgsr'], 'Specify data file');
   if isequal(fn,0), return; end;
   DFN = removeFileExtension([fp fn]);
   [fullName, Name] = localCheckDataFileName(DFN);
   if isempty(fullName), return; end;
   setstring(hh.DataFileEdit,Name);
end

%-------------locals-----------------------------------
%------------------------------------------------
function OK = local_InitSession(DFN, CalibParams, RecSide, requestID, Experimenter, NoMenu);
% initializes IDF/SPK files; 
% If all goes well, the global variable SESSION is initialized,
% which contains info about the current session
global NewSessionMenuStatus
if nargin<1, DFN = ''; end
if nargin<2, CalibParams = []; end
if nargin<3, RecSide = ''; end
if nargin<4, requestID = []; end
if nargin<5, Experimenter=''; end;
if nargin<6, NoMenu=0; end;
if ~NoMenu, hh = NewSessionMenuStatus.handles; end;

if isempty(requestID),
   requestID = UIintFromToggle(hh.requestIDButton)-1;
end
OK = 0;
% ---0.get experimenter's name if none was specified
if isempty(Experimenter) & ~NoMenu, 
   xh = hh.ExperimentorEdit; textcolors;
   if isequal('on', lower(get(xh, 'visible'))),
      Experimenter = trimspace(getstring(xh));
      set(xh, 'foregroundcolor', BLACK);
      if ~isvarname(Experimenter),
         if isempty(Experimenter), setstring(xh,'??'); end;
         errordlg('Invalid name of experimenter');
         set(xh, 'foregroundcolor', RED);
         return;
      end
      % check if experimenter is known
      [BUd, BUexist, XPlist] = backupdir(0,Experimenter,0);
      if ~BUexist,
         ch = warnchoice1('Unknown experimenter',...
            'Unknown experimenter',['&Unknown experimenter: ''' Experimenter, '''',...
               '&Known experimenters are: &   ',...
               XPlist, ...
               '&Proceed anyhow?'],...
            'yes', 'no');
         if isequal('no', ch), return; end;
         % yes: create backup directory for new experimenter
         backupdir(0,Experimenter,1);
      end
   end
end
% ---1. check syntax of data file name
if isempty(DFN), % get datafilename from DataFileEdit uicontrol
   DFN = getstring(hh.DataFileEdit);
end
[fullName, Name] = localCheckDataFileName(DFN);
if isempty(fullName), return; end;
% ---2. try to initialize PDP files - PDPinitFiles2 will check for
% existing files, etc, and handle errors
if ~InitPDPfiles2(Name, NoMenu), return; end;
% find out what's the index of next sequence
header = idfHeaderRead(fullName);
currentSeqIndex = header.num_seqs;
% index of new style data
H = HeaderSGSRdataFile(Name);
SGSRSeqIndex = H.Nseq;
% ---3. Calibration:
% - Check choice of calibration. 
% - Perform calibration if needed;
% - read calibration data.
if nargin<2, % get calib params from UIcontrols
   DAchannel = get(hh.AcoustChannelButton, 'string');
   DAchannel = DAchannel(1); % B/L/R
   CalibMode = get(hh.CalibrationButton, 'string');
else,
   DAchannel = CalibParams.DAchannel;
   DAchannel = DAchannel(1); % B/L/R
   CalibMode = CalibParams.CalibMode;
end

switch CalibMode
case 'MEASURE'
   ERCname = localCheckERCfilename(Name);
   if isempty(ERCname), return; end;
   ERCname = launchAndReturn('ERC',DAchannel,ERCname);
   if isempty(ERCname), return; end;
case 'Existing data'
   if NoMenu,
      ERCfile = CalibParams.ERCfile;
      ERCdir = CalibParams.ERCdir;
   else,
      fmask = [datadir '\' Name '.ERC'];
      qq = dir([datadir '\' Name '*.ERC']); % all ERC files with correct prefix
      if ~isempty(qq), % find most recent ERC among them
         for ii=1:length(qq),
            qdate(ii) = datenum(qq(ii).date);
         end
         [dum, irecent] = max(qdate);
         fmask = [datadir '\' qq(irecent).name];
      end
      [ERCfile ERCdir]= uigetfile(fmask, 'Select ERC calibration file');
   end
   if isequal(ERCfile,0), return; end;
   ERCname = RemoveFileExtension([ERCdir ERCfile]);
case 'FLAT',
   % fake calibration
   if isfield(CalibParams, 'maxLevel'),
      maxLevel = CalibParams.maxLevel;
   else, % prompt user
      maxLevel = inputDlg('dB SPL corresponding to maximum DAC output:', ...
         'FLAT calibration');
      if isempty(maxLevel), return; end;
      maxLevel = str2num(maxLevel{1});
      if isempty(maxLevel), return; end;
   end
   ERCname = ['!FLAT @ ' num2str(round(maxLevel)) ' dB SPL'];
end % switch
if ~CDuseCalib(ERCname, DAchannel), return; end
% start time
% date
startTime = round(datevec(now));
startTime = startTime([3 2 1 4 5 6]); % d-m-y date order
% recording side
if nargin<3,
   RecSide = UIintFromToggle(hh.RecSideButton);
end
% initialize global SESSION
dataFile = fullName;
iSeq = currentSeqIndex + 1;
SGSRSeqIndex = H.Nseq + 1;
SeqRecorded = [];
RecordingSide = channelChar(RecSide,1);
ERCfile = ERCname;
leftDACear = CDleftDACear;
PenDepth = nan; ElectrodeNumber = 1;
KeepPen  = 1; 
NotifiedComputer = '';
NotifyPort = 0;
% look if there is a log file and get counter status stored therein
[iCell, iseqPerCell] = IDcountersFromLog(fullName);
iJustRecorded = nan;
global SESSION
SESSION = CollectInStruct(startTime, dataFile, ...
   iSeq, SeqRecorded, SGSRSeqIndex, iJustRecorded, ...
   RecordingSide, ERCfile, leftDACear, DAchannel,...
   requestID, KeepPen, ElectrodeNumber, PenDepth, NotifiedComputer, NotifyPort, ...
   iCell, iseqPerCell, Experimenter);

% if we made it to here, everything is OK to start the session
% so set the OK flag and delete the menu
global SGSR
SGSRinitMenuStatus.OK = 1;
addToLog(['Session initialized: ' Name], ...
   ['Started @: ' trimspace(num2str(SESSION.startTime))], ...
   ['Experimenter: ' SESSION.Experimenter], ...
   ['Rec Side: ' SESSION.RecordingSide], ...
   ['D/A chan: ' SESSION.DAchannel], ...
   ['ERC: ' SESSION.ERCfile], ...
   ['SGSR version: ' currentVersion], ...
   ['samFreqs: ' trimspace(num2str(SGSR.samFreqs,9)) ' Hz'], ...
   ['maxSampleRatio: ' trimspace(num2str(SGSR.maxSampleRatio,9))], ...
   ['ClockRatio: ' trimspace(num2str(SGSR.ClockRatio,15))] ...
   );
OK = 1;

%------------------------------------------------
function [fullName, Name] = localCheckDataFileName(DFN);
% check name for datafile; update dir etc
fullName = '';
[Drive Dir Name Ext] = ParseFileName(DFN);
Dir = [Drive ':' Dir];
if isempty(Name),
   eh = errordlg('specify filename and retry', ...
      'No Data Filename specified');
   uiwait(eh); 
   return;
end
if isequal(Dir,':'),
   Dir = datadir;
elseif ~exist(Dir, 'dir'),
   eh = errordlg('Invalid data directory:', ...
      ['''' Dir '''']);
   uiwait(eh); 
   return;
end
if ~isequal(lower(datadir),lower(Dir)),
   setDirectories('external','IdfSpk','Data directory', Dir);
end
fullName = [datadir '\' Name];
%---------------------------------------------
function ERCname = localCheckERCfilename(Name);
ERCname = '';
while 1,
   cand = FullFileName(Name, datadir, 'ERC');
   if ~exist(cand, 'file'), 
      ERCname = Name;
      break; % files with same name do not exist, all is well
   else, % files with same name exist - ask user what to do
      answer = warnchoice1('ERC files exist', 'WARNING',...
         ['\ERC file named: ' Name '.ERC\already exist.' ...
            '\ \What to do?' ...
            '\(Deviant Name -> ERC name differs from spikedata filename)'], ...
         'Deviant Name', 'Overwrite', 'CANCEL');
      switch answer
      case 'Deviant Name'
         [fn fp]= uiputfile([datadir filesep '*.ERC'], 'select ERC filename');
         if fn==0, return; end; % user cancelled
         Name = removeFileExtension(fn);
      case 'Overwrite', 
         delete(cand);
         ERCname = Name;
         break;
      case 'CANCEL', return;
      end; % switch
   end; % if isequal(exist..
end
