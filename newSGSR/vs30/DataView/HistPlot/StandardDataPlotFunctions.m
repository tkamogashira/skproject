function OK = StandardDataPlotFunctions(keyword, figh, cbh);
% StandardDataPlotFunctions - deals with standard options of dataplot such as splitting windows, etc

OK = 1;
switch keyword,
case 'close',
   dialogDefaults(figh, 'savecurrent');
   delete(figh); % not gcbf! close may be called by parent window's closereq
case {'ViewMenu', 'ParameterMenu'}, % just pulldown menus
case 'ChangeParamMenuItem',
   % launch modal param-setting dialog for current settings
   DataPlotParam(cbh);
case 'DefaultParamsMenuItem'
   DataPlotParam(cbh, 'defaultanalysis');
case 'Split2MenuItem', % split in two windows
   SplitDataPlot(figh);
case 'AllSubsMenuItem',
   SplitDataPlot(figh,1); % "unsplit"
case 'keypress',
case {'refresh', 'RefreshMenuItem', 'resize'}, % UCPST('resize', FIGH) ...
   if isempty(figh), figh = gcbf; end; % callback
   if isempty(figh), error('No figure handle specified'); end;
   try, [plotter, ds, params]=HistPlotAppData(figh);
   catch, return; % cannot retrieve what is shown - don't crash just because of that
   end
   eval([plotter '(ds, [], figh, params);']);
   dialogDefaults(gcf, 'savecurrent');
case 'ShowRecOrderMenuItem',
   [plotter, ds, params]=HistPlotAppData(figh);
   params.iSub = 0;
   eval([plotter '(ds, [], figh, params);']);
case 'ShowUpOrderMenuItem',
   [plotter, ds, params]=HistPlotAppData(figh);
   params.iSub = 'up';
   eval([plotter '(ds, [], figh, params);']);
case 'ShowDownOrderMenuItem',
   [plotter, ds, params]=HistPlotAppData(figh);
   params.iSub = 'down';
   eval([plotter '(ds, [], figh, params);']);
case 'ViewStimMenuItem',
   [plotter, ds, params]=HistPlotAppData(figh);
   showstimparam(ds,1); % show current ds in NotePad
case 'DataMenu', % No action, just a pulldown menu
case 'Export2FileMenuItem', 
   DataPlotExport(figh, 'file');
case 'Export2VarMenuItem', 
   DataPlotExport(figh, 'var');
case 'Export2ScreenMenuItem', 
   DataPlotExport(figh, 'screen');
otherwise, OK = 0; % unknown keyword
end % switch/case


