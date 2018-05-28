function YY = ABR(DAchan, varargin);
% ABR - perform ABR measurement and plot
%   R = ABR(Chan), where  Chan=0,1,2 = Left,Right,Both, launches
%   an ABR measurement and returns the data data in struct R.
%   After each complete measurement, the data are automatically 
%   appended to the datafile (see below).
%
%   ABR(Chan, 'prop', value, ...) uses non-default values
%   for given properties. To list all prpoerties with their default 
%   values, call ABR without any arguments. For more information view 
%   the mfile ABR.m and look under the heading "parameters"
%   All parameters are single numerical values except:
%      'stimType':    either 'tone' or 'click'
%      'frequency':   may be vector of respective values
%      'SPL':         may be vector of respective values
%
%   ABR('file') opens a dialog for specifying the datafile.
%   ABR('file' , FN) defines filename DF in datadir.
%   If no file has been specified and a measurement is
%   performed, the user will be prompted for a filename automatically.
%
%   After the finishing the measurement, the user is asked to provide 
%   details about ampifier settings, etc, by editing a file in NotePad. 
%   The default comments are in the file ABRtemplate.m which can be edited
%   to change the settings as they appear when NotePad opens.
%
%   Examples:
%   ABR(1, 'toneDur', 15, 'SPL',  80, 'frequency', 1000*[1 2 4 8 16])
%   ABR(2, 'stimType', 'click', 'SPL', [70 60 50 40])

% MMCL  - 11/10/07 Updated to store data at all SPL levels. Earlier version 
% only stored last SPL. Lines 180-186. 

global SGSR
persistent FN lastY
YY = lastY;
if nargin<1, 
   DAchan = 'params'; 
end
   
% --------parameters-------------
PP.stimType = 'tone'; % tone/click
PP.frequency = 1000*[0.25 0.5 1 2 4 8]; % Hz tone freq
PP.toneDur = 10; % ms duration of tones
PP.clickDur = 0.1; % ms duration of clicks
PP.doAlternate = 1; % 0/1 =yes/no alternate polarity
PP.rampDur = 1.5; % ms ramp duration
PP.preDur = 10; % ms recording before tone
PP.postDur = 10; % ms recording before tone
PP.Nrep = 256; % # reps per tone
PP.SPL = 70; % dB SPL ball park level
PP.doPlot = 1; % 1/0 =yes/no plot during measurement
% --------end parameters-------------
defFN = fieldnames(PP); % for check of varargin

% non-measuring options are all of the form ABR(keyword, ...)
if ischar(DAchan),
   switch lower(DAchan),
   case 'file', 
      FN = localFilename(varargin{:});
      if isempty(FN), error('No filename specified.'); end
      disp(strvcat('Data will be appended to datafile',FN));
   case 'params', YY = PP; % just return default parameters
   case 'lastdata', % just return previous data
   otherwise, error(['Unknown option "' DAchan '".']);
   end % switch IDstr
   return;
end

if nargin>1,
   PP = combineStruct(PP, struct(varargin{:}));
   if ~isequal(defFN, fieldnames(PP)),
      error('Invalid parameter specified; Type "ABRmeasure params" to view params.');
   end
end

% make sure datafile exist
if isempty(FN), 
   FN = localFilename;
   if isempty(FN), error('No datafile was specified.'); end;
end
Ndataset = localNdatasetInFile(FN);
idataset = Ndataset+1;

YY.Datafile = FN;
YY.idataset = idataset;
YY.DAchan = DAchan;
YY.params = PP;

% derived params
Nrep = 2*ceil(PP.Nrep/2); % need even # reps to balance alternating polarity
switch lower(PP.stimType),
case 'tone',
   freq = PP.frequency;
   Nfreq = length(freq);
   maxFreq = max(freq);
   stimDur = PP.toneDur;
case 'click',
   Nfreq = 1;
   freq = inf;
   maxFreq = maxStimFreq;
   stimDur = PP.clickDur;
otherwise, 
   error(['Invalid stimType "' PP.stimType '"']);
end
Nlevel = length(PP.SPL);
if (Nfreq>1)&(Nlevel>1),
   error('Frequency and SPL cannot both be vectors.');
end
[samfreq, ifilt] = safeSampleFreq(maxFreq);
Nsam = ceil(samfreq*stimDur*1e-3);
NrampSam = round(samfreq*PP.rampDur*1e-3);
NpreSam = round(samfreq*PP.preDur*1e-3);
NpostSam = round(samfreq*PP.postDur*1e-3);
NsamTot = Nsam + NpreSam + NpostSam;

% prepare & generate stim waveform
RiseWin = sin(linspace(0,pi/2,NrampSam)).^2; % rise window
irise = 1:NrampSam;
FallWin = flipLR(RiseWin); % fall window
ifall = (Nsam-NrampSam+1:Nsam);
% plot(irise, RiseWin); xplot(ifall, FallWin,'r');

% prepare plotting
Nplot = Nfreq*Nlevel+1; % plus one for params
if PP.doPlot,
   hh = subPlotDivide(figure, -Nplot, 'time (ms)', ...
      [0 1e3/samfreq*NsamTot]-PP.preDur, 'ABR (A.U.)');
   if atBigScreen, set(gcf,'position', [113   187   674   493]); end;
end

iplot = 1;
YY.Response_DC = []; YY.Response_AC = [];
for ifreq=1:Nfreq,
   for ilevel=1:Nlevel,
      iplot = iplot+1;
      curSPL = PP.SPL(ilevel);
      Atten = SGSR.defaultMaxSPL - curSPL; % attenuation re max level
      AnaAtten = min(Atten, MaxAnalogAtten); % analog part of attenuation
      NumAtten = Atten - AnaAtten; % numerical part of attenuation
      linAmp = maxMagDa*db2a(-NumAtten); % linear amplitude of tone buffer
      curFreq = freq(ifreq); % current freq 
      if isinf(curFreq), % click
         WF = linAmp*ones(1,Nsam);
      else % tone
         % compute current angular freq in radians per sample
         radPerSam = 2*pi*curFreq/samfreq; 
         WF = linAmp*sin(radPerSam*(1:Nsam));
         % gating
         WF(irise) = WF(irise).*RiseWin;
         WF(ifall) = WF(ifall).*FallWin;
      end
      % add surrounding silence
      WF = [zeros(1,NpreSam) WF zeros(1,NpostSam)];
      RS_DC = 0; RS_AC = 0;
      RepeatCalibPlayRecSys2('prepare', WF, DAchan, ifilt, AnaAtten,1); % pos
      RepeatCalibPlayRecSys2('prepare', -WF, DAchan, ifilt, AnaAtten,2); % neg
      ifreq
      for irep = 1:Nrep,
         pola = 2-rem(irep,2); % 1=+, 2=-
         if ~PP.doAlternate, pola = 1; end;
         [recSig, ANOM] = RepeatCalibPlayRecSys2('playrec', pola);
         Sign = 3-2*pola; % 1=+, -1=-
         RS_DC = RS_DC + recSig;
         RS_AC = RS_AC + Sign*recSig;
         % help interrupt come through
         if isequal(0, rem(irep,20)), 
            drawnow;
         end
      end
      % plot current curve
      if PP.doPlot,
         axes(hh(iplot)); set(gca,'nextplot', 'add');
         title([num2sstr(curFreq) ' Hz  ' num2sstr(curSPL) ' dB' ]);
         dplot([1e3/samfreq -PP.preDur], RS_DC/Nrep);
         dplot([1e3/samfreq -PP.preDur], RS_AC/Nrep, 'r');
      end
      RepeatCalibPlayRecSys2('cleanup');
      YY.Fsample = samfreq;
      YY.Response_DC(ifreq,ilevel,:) = RS_DC;
      YY.Response_AC(ifreq,ilevel,:) = RS_AC;
   end
end;
YY.Response_DC = squeeze(YY.Response_DC);
YY.Response_AC = squeeze(YY.Response_AC);

% show parameter info in plot
if PP.doPlot,
   if isequal('tone', PP.stimType),
      durStr = [num2sstr(PP.toneDur) '-ms ']
   else,
      durStr = [num2sstr(PP.clickDur) '-ms ']
   end
   [pp dfn] = fileparts(FN);
   qstr = strvcat(['ABR  ' dfn '  #'  num2sstr(YY.idataset)],...
      [durStr PP.stimType 's'],...
      [num2sstr(PP.Nrep) ' reps,  ' channelChar(DAchan,1)  ' chan']);
   qpos = get(hh(1),'position');  delete(hh(1));
   uicontrol('style', 'text', 'position', qpos, 'horizontalAlign', 'left', ...
      'units','normalized', 'string', qstr, 'backgroundcolor', [1 1 1]);
end

% store data in persistent variable
lastY = YY;

% save data in file
localSave(FN, YY);

%-----------locals---------------------------
function DFN = localFilename(varargin);
persistent sdir
if nargin>1, 
   DFN = fullFileName(varargin{1}, datadir, 'ABRdata');
   return;
end
% prompt for a name
DFN = '';
if isempty(sdir), sdir = datadir; end
% get filename: default dir is datadir, def extension is ABRdata
[nn pp] = uiputfile([sdir '\*.ABRdata'], 'specify filename for ABR data.');
if isequal(0,nn), return; end;
sdir = fileparts(pp);
DFN = fullFileName([pp nn], '', 'ABRdata');
if ~isequal(2,exist(DFN)), % initialize
   Ndataset = 0;
   save('-mat', DFN, 'Ndataset');
end


function localSave(FN, YY); % save ABR data that are in struct YY
% user may add data
TFN = [tempname '.txt']; 
copyfile(which('ABRtemplate.m'), TFN);
cmd = ['!notepad  ' TFN ];
eval(cmd);
fid = fopen(TFN,'rt') ; 
YY.Comments = fscanf(fid,'%c');
fclose(fid);
% save YY as separate variable 'ABR1' 'ABR2' etc
VarName = ['ABR' num2sstr(YY.idataset)];
eval([VarName ' = YY;']);
Ndataset = YY.idataset;
if isequal(2, exist(FN)), XXX={'-append'}; else, XXX = {}; end;
save(FN, VarName, 'Ndataset', '-mat', XXX{:});

function Ndataset = localNdatasetInFile(FN);
% get # datasets in datafile
Ndataset = 0;
if isequal(2, exist(FN)),
   load('-mat', FN, 'Ndataset');
end




