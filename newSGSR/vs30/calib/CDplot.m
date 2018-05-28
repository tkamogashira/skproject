function CDplot(CD, varargin);
% CDplot - plot calibration data vs12 and on

if nargin<1, % just make existing plot visible, if any
   fh = findobj('tag','TrfPlotMenu');
   try, 
      figure(fh); 
      okh = findobj(fh, 'tag', 'OKButton');
      waitfor(okh, 'userdata');
   end; 
   return;
end
if ischar(CD), % read calib data from filename
   [CD, fname] = CDread(CD, varargin{:});
   if isempty(CD), return; end; % user cancelled
   if ~isfield(CD, 'CalType'), % old-style - delegate
      if ~isempty(fname), plotCalibFile(fname); end;
      return;
   end
end
% extract name for use in legend
CName = getfieldordef(CD, 'filename', '');

chanSpec = '';
if isequal('ERC',CD.CalType) 
   if ~isfield(CD,'TRF'), % no selection yet - force one
      chanSpec = localPickChan, % user picks channel
      CD = getfield(CD, chanSpec);
      chanSpec = ['-' chanSpec]; % format for legend
   else, % display channel as stored in data 
      qqq = 'LR'; chanSpec = ['-' qqq(CD.DAchan)];
   end
end

global SGSR TrfPlotMenuStatus

if isempty(findobj('tag','TrfPlotMenu')),
   TrfPlotMenuStatus = [];
   hh = openUImenu('TrfPlot');
   TrfPlotMenuStatus.SGSRversion = SGSR.version;
   TrfPlotMenuStatus.dBmin = inf;
   TrfPlotMenuStatus.dBmax = -inf;
   TrfPlotMenuStatus.count = 0;
   TrfPlotMenuStatus.names = {};
   set(hh.ExportButton,'visible','off');
   set(hh.PRLplotMenuItem, 'callback', 'cdplot *;')
   set(hh.ERCplotMenuItem, 'callback', 'cdplot ERC;')
   % create axes handles anew and store handles 
   h1 = subplot(2,1,1); set(h1,'pos', [0.1300    0.5780    0.6700    0.3270]);
   h2 = subplot(2,1,2); set(h2,'pos',[0.1300    0.1300    0.6700    0.3270]);
   set([h1 h2],'nextplot','add');
   TrfPlotMenuStatus.handles.AmplitudeAxes = h1;
   TrfPlotMenuStatus.handles.PhaseAxes = h2;
else, % get relevant handles
   hh = TrfPlotMenuStatus.handles;
   h1 = TrfPlotMenuStatus.handles.AmplitudeAxes;
   h2 = TrfPlotMenuStatus.handles.PhaseAxes;
end;

% cannot plot old- and new-style data in one plot
if localConflictingVersions, return; end;

axes(h1); grid on;

Nfilt = length(CD.TRF);
% get freq spacing in kHz
if isfield(CD, 'DF'), DF = 1e-3*CD.DF;
else, DF = 1e-3*CD.Freq.DF;
end
dBmin = TrfPlotMenuStatus.dBmin;
dBmax =  TrfPlotMenuStatus.dBmax;
pc = ploco(TrfPlotMenuStatus.count+1);
switch CD.CalType, 
case 'PRL', % probe loss - acoustic trf -> no absolute SPLs
   RefLevel = 0; % relative levels are plotted
otherwise,  % plot max attainable tone levels in dB SPL
   RefLevel = maxnumtonelevel + a2db(1/20e-6);
end
if isempty(CName),
   try, % to extract filename from current session
      global SESSION; 
      [dum CName] = fileparts(SESSION.dataFile);
      CName = [upper(CName) '.' CD.CalType ' (new)'];
   catch,
      CName = ['XXXX.' CD.CalType ' (new)'];
   end
else, [pp nn ee] = fileparts(CName); CName = [nn ee];
end
% plot the curves
for ifilt=1:Nfilt,
   trf = CD.TRF{ifilt}; % transfer function in DACbit/Pa
   trf(find(trf==0)) = nan; % do not plot zer0 components (not measured)
   % plot relative level (PRL) or maximum SPL of tone (CAV, PRB, ERC)
   maxAmp = a2db(abs(trf)) + RefLevel;
   dBmax = max(dBmax, max(10*ceil(0.1*maxAmp)));
   dBmin = min(dBmin, min(10*floor(0.1*maxAmp)));
   dBmin = max(dBmin, dBmax-200); % do not show enormous troughs
   Phi = unwrap(angle(trf))/2/pi;
   lineWidth = 0.5*(Nfilt-ifilt+2);
   % error ('freq axis?')
   axes(h1); xdplot(DF(ifilt), maxAmp, pc, 'linewidth', lineWidth);
   axes(h2); xdplot(DF(ifilt), Phi, pc, 'linewidth', lineWidth);
   Export.maxAmp{ifilt} = maxAmp;
   Export.Phase{ifilt} = Phi;
   Export.DF(ifilt) = DF(ifilt);
   TrfPlotMenuStatus.names = {TrfPlotMenuStatus.names{:} ,...
         [CName chanSpec '/' num2str(ifilt)]};
end
axes(h1); ylabel('Amplitude (dB SPL)');
axes(h2); ylabel('Phase lead (cycle)');
set(h1, 'ylim', [dBmin, dBmax]);
legend(TrfPlotMenuStatus.names{:});
% bookkeeping for next time
TrfPlotMenuStatus.dBmin = dBmin;
TrfPlotMenuStatus.dBmax = dBmax;
TrfPlotMenuStatus.count = TrfPlotMenuStatus.count+1;
% store the export data in figure
Export.name = [CName ' ' chanSpec];
set(hh.Iam, 'userdata', Export); % store last curve in graph for export purposes
% wait
okh = findobj(hh.Root, 'tag', 'OKButton');
waitfor(okh, 'userdata');

%------------------------------------------------------
function doret = localConflictingVersions;
global TrfPlotMenuStatus
vs = getFieldOrDef(TrfPlotMenuStatus, 'SGSRversion', 0);
doret = (vs<1.2);
if doret,
   mess = strvcat('Old- and new-style calibration data cannot be plotted', ...
      'in a single graph.',...
      'Close hidden calibration plot first.');
   eh = errordlg(mess, 'version conflict', 'modal');
   uiwait(eh);
   plotcalib; % unveal hidden plot
end

function chch = localPickChan; % user picks channel
chch = warnchoice1('Select D/A Channel to plot', '', '\Channel to plot:', 'Left','Right');
chch = chch(1);

