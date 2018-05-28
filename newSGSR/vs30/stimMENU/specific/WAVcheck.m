function OK = WAVcheck(OnlyWavListFile);

% Checks params for WAVmenu and stores the stimulus info in
% globals SMS  
% SGSR version 06 & higher

if nargin<1, 
   OnlyWavListFile=0; 
end;

global StimMenuStatus SGSR DEFDIRS
textcolors;
persistent WAVdetails oldWavFileNames oldCalibMode oldActiveCh InitialCall oldartMaxmag
hh = StimMenuStatus.handles;
hWAV = hh.WAVinfo;
pp = []; % reset
StimMenuStatus.params = [];


OK = 0;
StimMenuStatus.paramsOK = 0;

% initialize value of wavlist dir if empty
if ~isfield(StimMenuStatus,'wavlistDir'),
   StimMenuStatus.wavlistDir = DEFDIRS.Wavlist;
end

% very first call: don't let user wait for processing the previous
% wavlist file
if isempty(InitialCall),
   InitialCall = 0;
   return;
end

% process wavlist file
pp.wavlistname = get(hh.WAVlistEdit, 'string');
[wavFileNames, Nwav, OKwl] = localReadWavList(pp.wavlistname);
if ~OKwl, return; end;

% visit all edit controls and look if their formats are OK  XXXX not ready
UIinfo('Checking parameters...');
pp.stimtype = 'wav';
pp.reps = round(abs(UIdoubleFromStr(hh.repsEdit)));
pp.interval = UIdoubleFromStr(hh.IntervalEdit);

pp.atten = UIdoubleFromStr(hh.LevelValueEdit);
pp.artMaxmag = UIdoubleFromStr(hh.ArtMaxmagEdit);
if ~checkNaNandInf(pp.artMaxmag), return; end
[pp.active, acOK] = activeChanCheck;
if ~acOK, return; end
pp.activeDAchannels = get(hh.ActiveChannelButton,'string');
pp.calibmode = get(hh.LevelCalibButton,'string');

pp.order = UIintfromToggle(hh.OrderButton)-1; % 0|1|2 rev|forw|random

StimMenuStatus.params = pp;


% --------read wave files only if same list hasn't been read before----
if ~isequal(oldWavFileNames, wavFileNames) ...
      | ~isequal(oldCalibMode, pp.calibmode) ...
      | ~isequal(oldartMaxmag, pp.artMaxmag) ...
      | ~isequal(oldActiveCh, pp.active),
   % note: readWavFiles puts samples in global WAVdata
   [WAVdetails, OK] = ReadWavFiles(wavFileNames, pp);
   if ~OK, return; end;
   % update info for next decision
   oldWavFileNames = wavFileNames;
   oldCalibMode = pp.calibmode;
   oldartMaxmag = pp.artMaxmag;
   oldActiveCh = pp.active;
end

% update WAV info
maxDurStr = num2str(ceil(WAVdetails.maxDur));
WAVinfo = strvcat(...
   ['Duration of longest WAV file: ' maxDurStr ' ms'],...
   ' ',...
   ['RMS of most intense WAV file: '],...
   ['  ' trimspace(num2str(0.1*round(10*WAVdetails.GrandMaxSPL))) ' dB SPL']);
setstring(hWAV,WAVinfo);

% update max sample info
MaxMagSam = max(WAVdetails.MaxSample(:));
setstring(hh.MaxmagInfo ,sprintf('Max. sample Magn: %0.6f ',MaxMagSam));
if WAVdetails.ArtMaxActive,
   set(hh.MaxmagInfo, 'ForegroundColor', [0 0 0 ]);
   set(hh.ArtMaxmagPrompt, 'ForegroundColor', [0.5 0 0]);
else,
   set(hh.MaxmagInfo, 'ForegroundColor', [0.5 0 0 ]);
   set(hh.ArtMaxmagPrompt, 'ForegroundColor', [0 0 0]);
end

% update Nsubseq info 
Nsub = WAVdetails.Nwav;
if ~ReportNsubSeq(Nsub), return; end;

% copy WAVdetails in stimpars, also globally
pp.WAVdetails = WAVdetails;
StimMenuStatus.params = pp;

if OnlyWavListFile, return; end;

% proceed checking params

% any non-numerical input?
if any(isnan([pp.reps pp.interval pp.atten ])),
   UIerror('non-numerical values of numerical parameters');
   return;
end

% check if stimuli will fit in interval duration
if pp.interval<WAVdetails.maxDur,
   mess = strvcat('Interval too short for WAV data',...
      ['Interval will be increased to ' maxDurStr ' ms']);
   if StimMenuWarn(mess, hh.IntervalEdit), return; end;
   setstring(hh.IntervalEdit,maxDurStr); 
   UItextColor(hh.IntervalEdit, BLACK);
   pp.interval = ceil(WAVdetails.maxDur);
end

% copy params back into global StimMenuStatus
StimMenuStatus.params = pp;
% return
OK = 1;
StimMenuStatus.paramsOK = 1;
UIinfo('Checking parameters...OK');
ReportPlayTime(pp,Nsub);

% if we got here, params are OK
% Convert params to SMS stimulus specification (SGSR format)
global idfSeq SMS CALIB;
idfSeq = []; % obsolete for WAV stimulus menu

SMS = WAV2SMS(pp, WAVdetails);

% report succes internally & externally
StimMenuStatus.paramsOK = 1;
OK = 1;


% ------------------locals ------------
function [wavFileNames, Nwav, OK] = localReadWavList(wavlistname);
global StimMenuStatus
OK = 0;
wavFileNames = {};
Nwav = 0;
% does wavlistfile exist?
[PP NN EXT] = fileparts(wavlistname);
if isempty(NN),
   UIerror('No WavList file specified');
   return;
end;
if isempty(PP), PP = [StimMenuStatus.wavlistDir]; end;
if isempty(EXT), EXT = '.wavlist'; end;
fullWLname = [PP '\' NN EXT];
% check existence of wavlist file
if ~isequal(2,exist(fullWLname)),
   mess = ['Cannot find wavlist file ''' NN ''''];
   UIerror(mess);
   return;
end
% read wavlist file
wavFileNames = ...
   textread(fullWLname, '%s', 'commentstyle','matlab');
% check existence and file type of wav files listed
Nwav = length(wavFileNames);
for iwav=1:Nwav,
   [PP2 NN2 EXT2] = fileparts(wavFileNames{iwav});
   if isempty(EXT2), 
      EXT2 = '.wav'; 
   else, % check/provide extension
      if ~isequal(lower(EXT2),'.wav'),
         mess = strvcat(['''' NN2 EXT2 ''' is not a WAV file'],...
            ['[item number ' num2str(iwav) ' in wavlist file ''' NN ''']']);
         UIerror(mess);
         return;
      end
   end;
   % existence
   wavFileNames{iwav} = [PP2 '\' NN2 EXT2];
   wfn = wavFileNames{iwav};
   if ~isequal(2,exist(wfn)),
      mess = strvcat(['Cannot find wav file ''' NN2 ''''],...
         ['[item number ' num2str(iwav) ' in wavlist file ''' NN ''']']);
      UIerror(mess);
      return;
   end
end;
OK = 1;


