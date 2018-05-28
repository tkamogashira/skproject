function y= WAVcallback;

% generic callback function for WAV menu controls

TAG = get(gcbo,'tag');
switch TAG,
case 'WAVdetailsButton',
   localWAVdetails;
case 'WAVlistButton',
   localWAVbrowse;
case 'WAVeditButton',
   localWAVedit;
otherwise,
   error(['Unknown TAG ''' TAG '''.']);
end % switch


%--------locals--------------
function localWAVdetails;
global StimMenuStatus
OnlyReadWavList=1; % only wavlist is checked, not other stim params
StimMenuCheck(0,OnlyReadWavList);
hh = StimMenuStatus.handles;
% WAVcheck('JustReadWavList');
if ~isfield(StimMenuStatus.params,'WAVdetails'),
   mess = strvcat(['No waveList file was processed succesfully;'],...
      'Unable to provide details');
   UIerror(mess);
   return;
end
WD = StimMenuStatus.params.WAVdetails;
infoStr = strvcat(['WavList File ' upper(StimMenuStatus.params.wavlistname)]);
CLM = StimMenuStatus.params.calibmode;
infoStr = strvcat(infoStr, ['Calibration mode: ' CLM ]);
if isequal(CLM, 'ERC'),
   infoStr = strvcat(infoStr, ['ERC file(s): ' ERCfile ]);
end
infoStr = strvcat(infoStr, ' ');
for iwav=1:WD.Nwav,
   SN = WD.ShortName{iwav};
   FN = WD.wavFileNames{iwav};
   orFS = num2str(WD.Fsample(iwav));
   newFS = num2str(WD.NewFsample(iwav));
   resRat = num2str(WD.ResampleRatio(iwav));
   Dur = num2str(WD.Durations(iwav));
   SPL = num2str(WD.MaxSPLs(iwav,:));
   MaxSam = sprintf('%0.8f  ', WD.MaxSample(1));
   infoStr = strvcat(infoStr, ...
      ['-------' num2str(iwav) '---' SN '--------'],...
      ['Path: ' FN],...
      ['Original sample freq: ' orFS ' Hz'],...
      ['Resampled to: ' newFS ' Hz'],...
      ['Resample ratio: ' resRat],...
      ['Duration: ' Dur ' ms'],...
      ['Max. SPL : ' SPL ' dB'],...
      ['Max. sample magn. : ' MaxSam],...
      [' ']);
end
ViewTextInNotepad('wavdetails', infoStr, hh.Root);


function localWAVbrowse;
global StimMenuStatus
hh = StimMenuStatus.handles;
while 1,
   WLdir = StimMenuStatus.wavlistDir;
   [fn fp] = uigetfile([WLdir '\*.wavlist' ],'Choose wavlist file');
   if fn==0, return; end;
   StimMenuStatus.wavlistDir = removeLastSlash(fp);
   [PP NN EE] = fileparts(fn);
   if ~isequal(lower(EE),'.wavlist'),
      mess = 'Not a WAVLIST file';
      eh = errordlg(mess, 'Error opening WavList file','modal');
      drawnow;
      uiwait(eh); 
   else,
      setstring(hh.WAVlistEdit, NN);
      StimMenuCheck;
      break;
   end
end
% WAVcheck('JustReadWavList');

function localWAVedit;
global StimMenuStatus
hh = StimMenuStatus.handles;
while 1,
   WLdir = StimMenuStatus.wavlistDir;
   [fn fp] = uigetfile([WLdir '\*.wavlist' ],'Choose wavlist file');
   if fn==0, return; end;
   StimMenuStatus.wavlistDir = removeLastSlash(fp);
   [PP NN EE] = fileparts(fn);
   if ~isequal(lower(EE),'.wavlist'),
      mess = 'Not a WAVLIST file';
      eh = errordlg(mess, 'Error opening WavList file','modal');
      drawnow;
      uiwait(eh); 
   else,
      eval(['!notepad ' [fp, fn]]);
      setstring(hh.WAVlistEdit, NN);
      break;
   end
end

% WAVcheck('JustReadWavList');




