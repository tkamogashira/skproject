function [Details, OK] = ReadWavFiles(wavFileNames, pp);

% only samples in global WAVdata, details in output arg Details XXX
% Channels = 0|1|2 (both|left|right)
Channels = pp.active;
CalibMode = pp.calibmode;
ArtMaxmag = pp.artMaxmag;


CalibFIRdur = 30; %ms fir filter impulse response XXX global param
CalibFmin = 500; % Hz lowest freq for calibration pre-emp XXX global param

global WAVdata
markBuffer WAVdata; % global buffer will be deleted when next stimmenu is opened
WAVdata=[];

OK = 0;

Nwav = length(wavFileNames);
% read wavefiles
UIinfo('Reading WAV files...');
WAVdata = cell(1,Nwav);
Fsample = zeros(Nwav, 1);
Details = [];
AnyStereoFiles = 0;
shortName = cell(1,Nwav);
for iwav=1:Nwav,
   wfn = wavFileNames{iwav}; 
   [dummy sn ee] = fileparts(wfn); sn = [sn ee]; % short name incl. extension
   ShortName{iwav} = sn;
   try,
      [waveform, Fsample(iwav)] = wavread(wfn);
      if size(waveform,2)==2, AnyStereoFiles = 1; end;
   catch,
      mess = strvcat(['Error reading ''' sn ''''],...
         'Matlab error message:', lasterr);
      UImess(mess, nan, 1, '');
      return;
   end
   WAVdata{iwav} = collectInStruct(waveform);
end;
if AnyStereoFiles & (Channels~=0),
   ChName = {'left','right'};
   ActiveCh = ChName{Channels};
   mess = strvcat('dual-channel WAV files read;',...
      ['only ' ActiveCh ' channel will be played']);
   if StimMenuWarn(mess), return; end;
end

% if channels can be discarded, do it now (before time-consuming resampling)
% Note: duplication of identical channels will be done after resampling
if ~isequal(Channels, 0),
   for iwav=1:Nwav,
      if size(WAVdata{iwav}.waveform,2)>1,
         WAVdata{iwav}.waveform = WAVdata{iwav}.waveform(:,Channels);
      end
   end
end

% resample WAVdata
ResampleTolerance = 0.01; 
Durations = zeros(Nwav,1);
NewFsample = zeros(Nwav,1);
FilterIndex = zeros(Nwav,1);
ResampleRatio = zeros(Nwav,1);
RMS = zeros(Nwav,2);
global SGSR
for iwav=1:Nwav,
   MaxFsample = SGSR.samFreqs(end);
   MaxFilterIndex = length(SGSR.samFreqs);
   if Fsample(iwav)>MaxFsample,
      mess = strvcat(['sample rate of WAV file ''' ShortName{iwav} ''''],...
         ['is ' num2str(Fsample(iwav)) ' Hz.'],...
         ['Will be downsampled to ' num2str(MaxFsample) ' Hz.']);
      if StimMenuWarn(mess), return; end;
   end
   hiFreq = 0.5*Fsample(iwav); % Nyquist freq
   [NewFsample(iwav) FilterIndex(iwav)] = safeSampleFreq(hiFreq);
   if NewFsample(iwav)==0, 
      NewFsample(iwav)=MaxFsample; 
      FilterIndex(iwav) = MaxFilterIndex;
   end; 
   UIinfo(['Resampling WAV data from ' ShortName{iwav}]);
   [P Q] = cheaprat(NewFsample(iwav)/Fsample(iwav), ResampleTolerance);
   ResampleRatio(iwav) = P/Q;
   WAVdata{iwav}.waveform = resample(WAVdata{iwav}.waveform,P,Q);
   % Duplication of identical channels 
   if isequal(Channels, 0), % both channels active
      if size(WAVdata{iwav}.waveform,2)==1, 
         % only single channel in WAV data; duplicate
         WAVdata{iwav}.waveform = kron([1 1],WAVdata{iwav}.waveform);
      end
   end
   RMS(iwav,1) = rms(WAVdata{iwav}.waveform(:,1));
   RMS(iwav,2) = rms(WAVdata{iwav}.waveform(:,end));
   % calibration
   if isequal(CalibMode,'ERC'),
      % get impulse response of calibration pre-emp filter
      UIinfo(['Calibrating WAV data from ' ShortName{iwav}]);
      if Channels==0, % both channels: 2-column calib impulse response
         CalibFir = [...
               CalibImpulseResponse(NewFsample(iwav), CalibFIRdur, 'L', CalibFmin).' ...
               CalibImpulseResponse(NewFsample(iwav), CalibFIRdur, 'R', CalibFmin).' ];
      elseif Channels==1, % Left chan only
         CalibFir = ...
            CalibImpulseResponse(NewFsample(iwav), CalibFIRdur, 'L').';
      elseif Channels==2, % Right chan only
         CalibFir = ...
            CalibImpulseResponse(NewFsample(iwav), CalibFIRdur, 'R').';
      end
      WAVdata{iwav}.waveform = fftfilt(CalibFir, WAVdata{iwav}.waveform);
   end % isequal(calibMode
   Durations(iwav) = size(WAVdata{iwav}.waveform,1)/NewFsample(iwav)*1e3; % in ms
end; % for iwav
maxDur = max(Durations);


% determine maximum levels XXX no calibration yet
UIinfo('Determining Levels');
MaxSample = [0 0];
MaxSPLs = zeros(Nwav,2)-inf;
for iwav=1:Nwav,
   MaxSample(iwav, 1) = max(abs(WAVdata{iwav}.waveform(:,1)));
   MaxSample(iwav, 2) = max(abs(WAVdata{iwav}.waveform(:,end)));
end;
% set RMS of inactive channels to zero
if Channels==1, RMS(:,2) = 0;
elseif Channels==2, RMS(:,1) = 0;
end

MaxBoth = max(MaxSample(:));
ArtMaxActive = (MaxBoth<ArtMaxmag);
MaxBoth = max(MaxBoth,ArtMaxmag);
Scalor = MaxMagDA/MaxBoth;
MaxSPLs = a2db(RMS)+a2db(Scalor);
GrandMaxSPL = [max(MaxSPLs(:,1)) max(MaxSPLs(:,2))];
% if both channels are not active, select channel-specific params
if ~isequal(Channels,0),
   MaxSample = MaxSample(:, Channels);
   MaxSPLs = MaxSPLs(:, Channels);
   GrandMaxSPL = GrandMaxSPL(Channels);
end

Details = CollectInStruct(Nwav, wavFileNames, ShortName, ...
   Fsample, NewFsample, FilterIndex, ResampleRatio, ...
   Durations, maxDur, ...
   MaxSample, MaxBoth, ArtMaxActive, Scalor, MaxSPLs, GrandMaxSPL, RMS);
OK = 1;
