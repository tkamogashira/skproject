function y=SpikeRatePlot(varargin);

global PRPinstr PRPstatus SPIKES
persistent figh axish datah titleh maxh stoph X Y TimeWindow TWS
maxY = 50;

%---------INIT-------
if isequal(varargin{1},'init'), % initialize spike rate plot and data
   % figure handle is returned
   [figh axish X Y] = local_initPlot(maxY);
   y = figh;
   if nargin>1, TWS = varargin{2}; else, TWS ='BurstOnly';end;
   [TimeWindow TWS] = local_TimeWindow(TWS, TimeWindow);
   if isequal(TWS,'Manual'), % display the numbers
      TWStitle = [num2str(TimeWindow(1,1)) ' .. ' num2str(TimeWindow(1,2)) ' ms' ];
   else, TWStitle = TWS; % display the window style
   end
   % enable stopmenu 
   stoph = findobj(figh, 'tag', 'StopMenu');
   set(stoph, 'enable', 'on');
   [fstr, sstr] = local_ID;
   IDstr = [fstr '   ' sstr];
   TWstr = ['Time window: ' TWStitle];
   titleh = title(strvcat(IDstr,TWstr));
   gridVal = getFieldOrDef(PRPinstr.PLOT,'grid','off');
   grid(gridVal);
   return;
end
%---------ISOPEN-------
if isequal(varargin{1},'isopen'), % query
   y = local_IsOpen;
   return;
end
%---------UNDRAW-------
if isequal(varargin{1},'undraw'), % remove datapoints
   if ishandle(datah), delete(datah); end;
   if ishandle(maxh), delete(maxh); end;
   return;
end
%---------TWINDOW-------
if isequal(varargin{1},'twindow'), % change time window and refresh plot if necessary
   if ~local_IsOpen, % just change the default window
      [TimeWindow TWS] = local_setTWstyle(TWS);
      return;
   end
   if isequal('Manual',varargin{2}),
      [TimeWindow TWS] = local_setTWstyle(varargin{2});
   else, TWS = varargin{2}; 
   end
   Ycollected = find(~isnan(Y)); % subseq indices of collected data
   spikeRatePlot('init', TWS, varargin{3:end});
   SpikeRatePlot(Ycollected);
   SpikeRatePlot('draw');
   % if it was complete before, leave it complete again
   if ishandle(maxh), SpikeRatePlot('finish'); end;
   return;
end
%---------PROCESS subseq-------
if isnumeric(varargin{1}), % get spike statistics of subsequence - don't plot yet
   Isub = varargin{1};
   if isequal(Isub,0), Isub=1:length(X); end;
   for isub=Isub(:).',
      if isub>0,
         % get spike rate using appropriate time window
         Y(isub) = getSpikeStats(isub, TimeWindow(isub,:));
      end
   end
   return;
end
%---------DRAW-------
if isequal(varargin{1},'draw'), % draw the data and flush
   ISDATA = ishandle(datah);
   if ishandle(datah), delete(datah); end;
   axes(axish);
   UX = X; UY = Y; LNST = 'none';
   if nargin>1, % the end: add line
      try,
         [UX isort] = sort(UX);
         UY = UY(isort);
         LNST = '-';
      catch, disp(lasterr);
   end
   end
   datah = line(UX,UY,'marker','x','linestyle',LNST);
   if any(Y>maxY),
      set(axish,'Ylim', [0 1.1*max(Y)]);
   end
   drawnow;
   return;
end
%---------FINISH-------
if isequal(varargin{1},'finish'), % draw all data, flush, and fill in details
   spikeRatePlot('draw', 'lin'); % draw all data 
   [maxSPR, indexOfMax] = max(Y); % max spike rate and corresponding subseq index
   if ~isnan(maxSPR),
      axes(axish);
      if ishandle(maxh), delete(maxh); end;
      maxh = line(X(indexOfMax),Y(indexOfMax),'linestyle','none','marker','o'); 
      TT = get(titleh,'string'); % current title
      MVV = PRPinstr.PLOT.VVlabel{indexOfMax}; % X-value at max spike rate
      maxStr = ['max rate @ ' MVV];
      TT = strvcat(TT, maxStr);
      setstring(titleh, TT);
   end
   % enable default menubar to print etc
   set(figh,'menubar', 'figure');
   OPMh = findobj(figh,'tag', 'OtherPlotMenu');
   set(OPMh, 'enable', 'on');
   TWh = findobj(figh,'tag', 'TimeWindowMenu');
   set(TWh, 'enable', 'on');
   % disable stopmenu 
   set(stoph, 'enable', 'off');
   return;
end
%-----------ALL---------------
if isequal(varargin{1},'all'), % all of the above
   spikeRatePlot('init',varargin{2:end});
   spikeRatePlot(0);
   spikeRatePlot('draw');
   spikeRatePlot('finish');
   return;
end
%---------CLOSE-------
if isequal(varargin{1},'close'), % close plot window if OK, return OK status
   y = 0; % pessimistic default
   % if stimmenu is busy, spikerateplot may not be closed
   if ~StimMenuMayBeClosed, return; end
   SaveMenuDefaults('SpikeRatePlot');
   delete(figh);
   clear global SpikeRatePlotMenuStatus
   figh = -1;
   y = 1;
   return;
end
%--------WHO---------------
if isequal(varargin{1},'who'), % echo all variables (debug)
   qq = who;
   for ii=1:length(qq),
      eval(['display(' qq{ii} ')'])
   end
   return;
end

%--------DEBUG---------------
if isequal(varargin{1},'debug'), % echo all variables (debug)
   keyboard;
   return;
end

error('Unknown option');

%----------locals--------------------------
function [io, hh]=local_IsOpen;
h = findobj(0,'tag','SpikeRatePlotMenu');
io = isequal([1 1],size(h));
if nargout>1,
   hh = CollectMenuHandles('SpikeRatePlot', h);
end

%------------------------------------------------------
function [FileStr, SeqStr] = local_ID;
[fp fname] = fileparts(dataFile);
FileStr = ['File: ' upper(fname)];
SeqStr = ['Seq: ' SeqIndex];
%------------------------------------------------------
function [figh, axish, X, Y] = local_initPlot(maxY);
persistent hh
global PRPinstr
%--plot------
[IsOpen hh] = local_IsOpen;
if ~IsOpen, % open new one
   hh = openUImenu('SpikeRatePlot');
end;
figh = hh.Root;
[filestr, seqstr] = local_ID;
set(figh,'name',[filestr  ' ---  ' seqstr]);
axish = hh.SpikeRatePlotAxes;
axes(axish);
figh = hh.Root;
% various defaults, set lin/log, disable menu items, set limits, etc
set(figh, 'menubar', 'none');
set(hh.TimeWindowMenu, 'enable', 'off');
set(hh.OtherPlotMenu, 'enable', 'off');
%--data, limits, etc------
X = PRPinstr.PLOT.varValues;
Y = nan+X;
Xscale = PRPinstr.PLOT.XScale;
if isequal('log', Xscale) & (min(X)>0) & ((max(X)/abs(1e-40+min(X)))>5),
   set(axish, 'XScale', 'log');
else,
   set(axish, 'XScale', 'linear');
end
% use temporary autoscale to get decent X limits, fix these
set(axish,'XLimMode','auto');
dummyh = line([min(X) max(X)],[0 maxY],'marker','.');
Xlim = get(axish, 'Xlim');
delete(dummyh);
set(axish,'Xlim',Xlim);
set(axish,'XLimMode','manual');
set(axish,'Ylim',[0 maxY]);
set(axish,'YlimMode', 'manual');
set(hh.OtherPlotMenu, 'enable', 'off');
xlabel(PRPinstr.PLOT.xlabel, 'FontSize',8, 'units', 'normalized', 'position', [0.5 -0.1]);
ylabel('Spikes/s', 'FontSize',8, 'units', 'normalized', 'position', [-0.1 0.5]);
title('Q', 'FontSize',8, 'units', 'normalized', 'position', [0.5 1.05]);
% drawnow; pause(2);
set(gca, 'FontSize', 8);
%------------------------------------
function  TW = local_getManualTW;
dprompt = ['Give start & end times in ms :'];
dtitle = 'TIME WINDOW FOR SPIKE_RATE PLOT';
OK = 0;
while ~OK,
   answer = inputdlg(dprompt,dtitle);
   if isempty(answer), TW = NaN; return; end;
   TW = str2num(answer{1});
   OK = isequal(size(TW),[1 2]);
   if ~OK,
      mess = 'Specify time window as 2 numbers, separated by whitespace'; 
   elseif TW(2)<TW(1),
      mess = 'Start time must not exceed end time';
   else,
      mess = CheckRealNumber(TW,[0 1e8],2);
   end
   if ~isempty(mess), 
      OK = 0;
      uiwait(errordlg(mess, 'ERROR', 'modal')); 
      drawnow;
   end;
end;
%------------------------------------
function [TW, TWstyle] = local_setTWstyle(TWstyle);
switch TWstyle
case 'Manual',
   TW = local_getManualTW;
   if isnan(TW), TWstyle='BurstOnly'; end;
case 'Interval',
   TW = nan;
case 'BurstOnly',
   TW = nan;
otherwise, error('unknown time-window style');
end   
%------------------------------------
function [TW, TWstyle] = local_TimeWindow(TWstyle, TW);
if isempty(TWstyle), TWstyle = 'BurstOnly'; end;
global PRPinstr
N = length(PRPinstr.RECORD);
switch TWstyle
case 'Interval',
   for ii=1:N,
      TW(ii,1:2) = [0 PRPinstr.RECORD(ii).repDur];
   end
case 'Manual',
   if size(TW,1)==1, TW=repmat(TW,N,1); end;
otherwise, 
   if ~isequal('BurstOnly', TWstyle),
      warning(['Unknown Time-window for spike rate plot: ''' TWstyle '''. Using BurstOnly by default']);
   end
   for ii=1:N,
      TW(ii,1:2) = [0 PRPinstr.RECORD(ii).repDur-PRPinstr.RECORD(ii).repsilDur];
   end
end





