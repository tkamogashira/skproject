function TrfPlotCallback

global TrfPlotMenuStatus DEFDIRS

TAG = get(gcbo,'Tag');
FIGH = gcbf;

switch TAG
case 'AmplitudeButton'
   axh = TrfPlotMenuStatus.handles.AmplitudeAxes;
   sc = get(axh,'XScale');
   if isequal(sc, 'linear')
       set(axh, 'XScale', 'log'); 
   else
       set(axh, 'XScale', 'linear');
   end
case 'PhaseButton'
   axh = TrfPlotMenuStatus.handles.PhaseAxes;
   sc = get(axh,'XScale');
   if isequal(sc, 'linear')
       set(axh, 'XScale', 'log'); 
   else
       set(axh, 'XScale', 'linear');
   end
case {'CloseButton','TrfPlotMenu'}
   saveMenuDefaults('TrfPlot');
   delete(FIGH);
case 'OKButton'
   set(gcbf,'visible','off');
   % changing of OK button's userdata resumes calling fnc
   set(gcbo,'userdata',rand(1));
case 'ExportButton'
   [fn fp] = uiputfile([DEFDIRS.Export '\*.txt'], ...
      ['Select file to write '  'trf']);
   if isequal(fn,0)
       return;
   end
   [Drive Dir Fname Ext] = ParseFileName([fp fn]);
   if isempty(Ext)
       Ext = 'txt';
   end
   Fname = [Drive ':' Dir '\' Fname '.' Ext];
   % data of most recent calibplot are stored in userdata of ExportButton
   % (see plotCalib). Retrieve  them and write save in ASCII format.
   EBhandle = findobj(FIGH, 'tag', 'ExportButton');
   CData = get(EBhandle, 'userdata');
   freq = 1e3*CData.Frequency; % kHz -> Hz
   
   ExpData= [freq.' CData.Amplitude.' CData.Phase.'];
   % header = '!Frequency (Hz)  Amplitude (dB)  Phase (cycles)';
   if exist(Fname, 'var')
       delete(Fname);
   end
   save(Fname, 'ExpData', '-ASCII')
end % switch




