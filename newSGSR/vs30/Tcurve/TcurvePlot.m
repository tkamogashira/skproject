function y = TcurvePlot(varargin);
global PRPinstr PRPstatus SPIKES
persistent figh axish datah maxh X Y


%---------INIT-------
if isequal(varargin{1},'init'), % initialize plot and data
   % figure handle is returned
   [figh axish X Y] = local_initPlot;
   y = figh;
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
%---------TITLE-------
if isequal(varargin{1},'title'), 
   axes(axish);
   title(varargin{2}, 'units', 'normalized');
   return;
end
%---------PROCESS subseq-------
if isnumeric(varargin{1}), % store threshold of subsequence - don't plot yet
   isub = varargin{1};
   Thr = varargin{2};
   Y(isub) = Thr;
   return;
end
%---------DRAW-------
if isequal(varargin{1},'draw'), % draw the data and flush
   ISDATA = ishandle(datah);
   if ishandle(datah), delete(datah); end;
   axes(axish);
   [dummy, Xi] = sort(X);
   datah = line(X(Xi),Y(Xi),'marker','x','linestyle','-');
   [CF, indexOfMax] = min(Y); % min threshold: CF
   CF = 0.1*round(10*CF);
   MVV = PRPinstr.PLOT.VVlabel{indexOfMax+1}; % X-value at max spike rate +1 due to spont seq
   Tstr = ['min Thr: ' num2str(CF) 'dB @ ' MVV];
   titleh = get(axish,'title');
   set(titleh, 'FontSize', 13);
   setstring(titleh, Tstr);
   drawnow;
   return;
end
%---------FINISH-------
if isequal(varargin{1},'finish'), % draw all data, flush, and fill in details
   TcurvePlot('draw'); % draw all data 
   [CF, indexOfMax] = min(Y); % min threshold: CF
   if ~isnan(CF),
      axes(axish);
      if ishandle(maxh), delete(maxh); end;
      maxh = line(X(indexOfMax),Y(indexOfMax),'linestyle','none','marker','o'); 
      titleh = get(axish,'title');
      TT = get(titleh,'string'); % current title
      TT = [SeqID(1) ' --- '];
      MVV = PRPinstr.PLOT.VVlabel{indexOfMax+1}; % X-value at max spike rate +1 due to spont seq
      CFStr = ['min thr:' num2str(CF,3) ' dB SPL @ ' MVV];
      TT = strvcat(TT, CFStr);
      setstring(titleh, TT);
   end
   % enable default menubar to print etc
   set(figh,'menubar', 'figure');
   return;
end
%-----------ALL---------------
if isequal(varargin{1},'all'), % all of the above
   TcurvePlot('init',varargin{2:end});
   TcurvePlot('draw');
   TcurvePlot('finish');
   return;
end
%---------CLOSE-------
if isequal(varargin{1},'close'), % close plot window if OK, return OK status
   y = 0; % pessimistic default
   % if stimmenu is busy, Tcurveplot may not be closed
   if ~StimMenuMayBeClosed, return; end
   SaveMenuDefaults('TcurvePlot');
   delete(figh);
   clear global TcurvePlotMenuStatus
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
h = findobj(0,'tag','TcurvePlotMenu');
io = isequal([1 1],size(h));
if nargout>1,
   hh = CollectMenuHandles('TcurvePlot', h);
end

%------------------------------------------------------
function [figh, axish, X, Y] = local_initPlot;
persistent hh
global PRPinstr
%--plot------
[IsOpen hh] = local_IsOpen;
if ~IsOpen, % open new one
   hh = openUImenu('TcurvePlot');
end;
figh = hh.Root;
axish = hh.TcurvePlotAxes;
axes(axish);
delete(findobj(axish,'type','line'));
figh = hh.Root;
% various defaults, set lin/log, disable menu items, set limits, etc
set(figh, 'menubar', 'none');
%--data, limits, etc------
X = PRPinstr.PLOT.varValues(2:end);
Y = nan+X;
minY = min(PRPinstr.PLOT.Ylim);
maxY = max(PRPinstr.PLOT.Ylim);
Xscale = PRPinstr.PLOT.XScale;
if isequal('log', Xscale) & (min(X)>0) & ((max(X)/abs(1e-40+min(X)))>5),
   set(axish, 'XScale', 'log');
else,
   set(axish, 'XScale', 'linear');
end
% use temporary autoscale to get decent X limits, fix these
set(axish,'XLimMode','auto');
dummyh = line([min(X) max(X)],[minY maxY],'marker','.');
Xlim = get(axish, 'Xlim');
delete(dummyh);
set(gca, 'FontSize', 8);
set(axish,'Xlim',Xlim);
set(axish,'XLimMode','manual');
set(axish,'Ylim',[minY maxY]);
set(axish,'YlimMode', 'manual');
xlabel(PRPinstr.PLOT.xlabel, 'FontSize',8, 'units', 'normalized');
ylabel('Threshold (dB SPL)', 'FontSize',8, 'units', 'normalized');
title('.', 'units', 'normalized')
set(figh, 'name', ['THR  --- ' SeqID(1)]);
%------------------------------------




