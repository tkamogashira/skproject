function figh = openDataPlot(figh, MenuName, callbackfnc, menucallbackfnc)
% openDataPlot - open new generic data plot or find existing one
%   Syntax: figh = openDataPlot(figh, MenuName, callbackfnc) 
%
%   If figh is not a valid handle, a new figure is opened by
%   calling OpenDialog(MenuName, callbackfnc) and the Data uimenus 
%   are added to it.
%
%   If figh is a valid figure handle, that figure is refreshed 
%   and made current. 
%
%   See also dataplotrefresh, openDialog, dataPlotHist, UCrate.

if nargin<4, menucallbackfnc = callbackfnc; end
% open figure or identify existing one
if isempty(figh), figh = nan; end; % invalid handle->newplot
if ~ishandle(figh), % open new figure
   hh=openDialog(MenuName, callbackfnc, 'Root:position');
   figh = hh.Root;
   % add Data menu with export options
   mh=adduimenu(figh, '&Data', 'Data', menucallbackfnc);
   ih=adduimenu(mh, ...
      {'Export to file' 'Export to MatLab variable' 'Display on screen'}, ...
      {'Export2File' 'Export2Var' 'Export2Screen'}, menucallbackfnc);
   % add new item to Parameter menu if any
   if isfield(hh, 'ParameterMenu'),
      adduimenu(hh.ParameterMenu, 'Set parameter defaults', 'DefaultParams', menucallbackfnc);
   end
   if isfield(hh, 'ChangeParamMenuItem'),
      set(hh.ChangeParamMenuItem, 'accelerator', 'Q');
   end
else, 
   figure(figh); % bring  figure to the fore
   dataplotrefresh(figh);  % clear plot but save uicontrols, etc
end;


