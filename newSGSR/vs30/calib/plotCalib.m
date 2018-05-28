function waith = plotCalib(CD, figname, legendLine, iPlot);
% plots calibration data as returned by performCalib

persistent legendStr
global TrfPlotMenuStatus
if nargin<1, % no new plot, justr make current one visible
   h = findobj('tag', 'TrfPlotMenu');
   if ishandle(h), 
      global TrfPlotMenuStatus
      figure(h); 
      waith = TrfPlotMenuStatus.handles.OKButton;
      waitfor(waith,'userdata');
   end
   return;
end

h = findobj('tag', 'TrfPlotMenu');
if isempty(h), % open new figure
   TrfPlotMenuStatus = [];
end
if localConflictingVersions, return; end;
TrfPlotMenuStatus.SGSRversion = 1.1; % to check for version conflicts


if nargin<2, figname = '---'; end;
if nargin<3, legendLine = figname; end;
if nargin<4, iPlot = []; end;

h = findobj('tag', 'TrfPlotMenu');
if isempty(h), % open new figure
   hh = openUImenu('TrfPlot');
   DeclareMenuDefaults('TrfPlot', 'Root:position');
   set(hh.Root, 'name', figname);
   legendStr = '';
   TrfPlotMenuStatus.NNN = 1;
else,
   hh = TrfPlotMenuStatus.handles;
   figure(hh.Root);
   set(hh.Root, 'name', 'Calibration plot');
   TrfPlotMenuStatus.NNN = TrfPlotMenuStatus.NNN + 1;
end;

if isempty(iPlot), iPlot = TrfPlotMenuStatus.NNN; end;

waith = hh.OKButton;
plotcol = plotcolors(iPlot);
h1 = hh.AmplitudeAxes;
h2 = hh.PhaseAxes;
set(h1,'nextplot','add');
set(h2,'nextplot','add');

for ii=1:length(CD),
   localPlotSingle(CD(ii),[h1 h2], plotcol, hh, length(CD)+1-ii);
   legendStr = strvcat(legendStr, [legendLine '/' num2str(ii)]);
end

% hack to get smaller legend
axes(h1);
LegendFontSize = 7;
axFontSize = get(h1,'fontsize');
set(h1,'fontsize',LegendFontSize);
legend(legendStr,0);
set(h1,'fontsize',axFontSize);

waitfor(waith,'userdata');


% f----------------------------
function localPlotSingle(CD, h, plotcol, hh, ilin);
if ilin==1,
   lll = {'linewidth', 1.5};
else,
   lll = {};
end
if isfield(CD,'Newstyle'),
   freq = 1e-3*expandFreqAxis(CD); % Hz->kHz
   phase = decompactArray(CD.phase)/(2*pi); % radians->cycles
   amp = decompactArray(CD.ampl);
else,
   freq = 1e-3*expandFreqAxis(CD.freqSpacing); % Hz->kHz
   phase = unwrap(CD.phase)/(2*pi); % radians->cycles
   amp = CD.ampl;
end
% amplitude is ratio of 16bitvaluesRec/16bitvaluesPlayed, with
% the attenuator wide open (see performCalib).
% What we want to plot is the SPL of each frequency when
% played as a single tone using the full 16-bit range.
% The SPL is the SPL as measured with the microphone
% used to measure the calibration at hand.
% we have db2a(ampl) = RMS16bRec/RMS16bPlay, [ampl is in dB] thus
% RMS16bRec = db2a(ampl)*RMS16bPlayed     (1)
% For a tone using the full DA range, we have:
% RMS16bitPlayed = MaxMagDA*sqrt(1/2);  (2) [sqrt(1/2) because rms(sin) = sqrt(1/2)]
% What about RMS16bRec?
% We know RMS_ADCat0dBSPL, it's a function of the microphone settings
% a2db(RMS16bitRecorded) = RecordedSPL + a2db(RMS_ADCat0dBSPL)  (3)
% Thus: 
% RecordedSPL = a2db(RMS16bitRecorded) - a2db(RMS_ADCat0dBSPL(micr.settings))
%             = a2db(db2a(ampl)*RMS16bPlayed) - a2db(RMS_ADCat0dBSPL(micr.settings))
%             = ampl + a2db(MaxMagDA*sqrt2) - a2db(RMS_ADCat0dBSPL(micr.settings))
% All this does not apply to PRL trfs, which are relative 
% trfs (acoustical->acoustical)
IsPRL = isfield(CD,'CAV') & isfield(CD,'PRB');
if (~IsPRL) & isfield(CD,'Settings'), % apply the above bullshit
   amp = amp + a2db(MaxMagDA*sqrt(0.5)) - a2db(RMS_ADCat0dBSPL(CD.Settings));
end
Nalign = min(100,length(phase)); 
phaseExcess = floor(phase(Nalign));
phase = phase-phaseExcess;
axes(h(1));
plot(freq, amp, lll{:}, 'color', plotcol);
axes(h(2));
plot(freq, phase, lll{:}, 'color', plotcol);
% store amp and phase of this, most recent , calib plot in
% the userdata of the ExportButton, so that they can readily be exported.
MostRecentData = struct('Frequency',freq,'Amplitude', amp, 'Phase', phase);
set(hh.ExportButton, 'userdata',MostRecentData);

%------------------------------------------------------
function doret = localConflictingVersions;
global TrfPlotMenuStatus
vs = getFieldOrDef(TrfPlotMenuStatus, 'SGSRversion', 0);
doret = (vs>1.1);
if doret,
   mess = strvcat('Old- and new-style calibration data cannot be plotted', ...
      'in a single graph.',...
      'Close hidden calibration plot first.');
   eh = errordlg(mess, 'version conflict', 'modal');
   uiwait(eh);
   plotcalib; % unveal hidden plot
end
