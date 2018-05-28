function y=ErevPlot(varargin);

global PRPinstr PRPstatus SPIKES
persistent figh axish datah titleh maxh X Y BinWidth
maxY = 50;

%---------INIT-------
if isequal(varargin{1},'init'), % initialize spike rate plot and data
   % figure handle is returned
   [figh axish X Y] = local_initPlot(maxY);
   y = figh;
   if isempty(BinWidth), BinWidth = PRPinstr.PLOT.BinWidth; end
   set(figh, 'name', ['Erev --- ' SeqID(1)]);
   return
end
%---------ISOPEN-------
if isequal(varargin{1},'isopen'), % query
   y = local_IsOpen;
   return;
end
%---------PROCESS subseq-------
if isnumeric(varargin{1}), % get spike statistics of subsequence - don't plot yet
   Isub = varargin{1};
   if isequal(Isub,0), Isub=1:length(X); end;
   for isub=Isub(:).',
      Spt = getSpikesOfRep(isub,1);  % in msPD1
      CycDur = PRPinstr.PLOT.CycleDur;
      RepDur = PRPinstr.RECORD(isub).repDur;
      AdaptDur = PRPinstr.PLOT.AdaptDur;
      Spt = Spt - AdaptDur;
      TailStart = RepDur-AdaptDur - rem(RepDur-AdaptDur,CycDur);
      Spt = Spt(find(Spt>0));
      Spt = Spt(find(Spt<TailStart));
      Spt = mod(Spt,4*CycDur);
      Nbin = round(CycDur/BinWidth); % # bins in ONE cycle
      Edges = BinWidth*(0:4*Nbin);
      SpikeCount = histc(Spt,Edges);
      %global FakeErev
      %FakeErev
      %if ~isempty(FakeErev),
      %   warning('FAKE EREV!!!!');
      %   Nbin
      %   SpikeCount = round(100*rand(1,4*Nbin));
      %end
      if isempty(SpikeCount), return; end
      SpikeCount = SpikeCount(1:end-1); % see help histc
      MeanCount = mean(SpikeCount)
      SpikeCount = 0.5*(SpikeCount(1:2*Nbin) -  SpikeCount(2*Nbin+1:end));
      X{isub} = 0.5*BinWidth+Edges(1:2*Nbin);
      Y{isub} = SpikeCount;
   end
   return;
end
%---------BINWIDTH-------
if isequal(varargin{1},'binwidth'), % draw the data and flush
   BW = inputdlg('New Bin Width in ms:', 'Specify Binwidth');
   if isempty(BW), return; end;
   BW = str2num(BW{1});
   if isempty(BW), return; end;
   BinWidth = BW(1);
   ErevPlot(0); % revisited all subseqs and re-sort spikes
   ErevPlot draw;
   local_title(axish(1), BinWidth);
   return;
end
%---------DRAW-------
if isequal(varargin{1},'draw'), % draw the data and flush
   for isub=1:length(X),
      axes(axish(isub));
      if ~isempty(Y{isub}), bar(X{isub},Y{isub}); end
   end
   drawnow;
   return;
end
%---------FINISH-------
if isequal(varargin{1},'finish'), % draw all data, flush, and fill in details
   ErevPlot('draw'); % draw all data 
   % enable default menubar to print etc
   set(figh,'menubar', 'figure');
   BWh = findobj(figh,'tag', 'BinMenu');
   set(BWh, 'enable', 'on');
   local_title(axish(1), BinWidth);
   return;
end
%-----------ALL---------------
if isequal(varargin{1},'all'), % all of the above
   ErevPlot('init',varargin{2:end});
   ErevPlot(0);
   ErevPlot('draw');
   ErevPlot('finish');
   return;
end
%---------CLOSE-------
if isequal(varargin{1},'close'), % close plot window if OK, return OK status
   y = 0; % pessimistic default
   % if stimmenu is busy, Erevplot may not be closed
   if ~StimMenuMayBeClosed, return; end
   SaveMenuDefaults('ErevPlot');
   delete(figh);
   clear global ErevPlotMenuStatus
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
h = findobj(0,'tag','ErevPlotMenu');
io = isequal([1 1],size(h));
if nargout>1,
   hh = CollectMenuHandles('ErevPlot', h);
end
%----------locals--------------------------
function local_title(ah, BinWidth);
axes(ah); % title placement
title([SeqID(1) ' --- Cycle histogram; binwidth ' num2str(BinWidth) ' ms']);

%------------------------------------------------------
function [figh, axish, X, Y] = local_initPlot(maxY);
persistent hh
global PRPinstr
CycDur = PRPinstr.PLOT.CycleDur;
[IsOpen hh] = local_IsOpen;
if ~IsOpen, % open new one
   hh = openUImenu('ErevPlot');
end;
figh = hh.Root;
figure(figh);
Nsub = length(PRPinstr.PLAY);
axish = subplotDivide(figh, Nsub,' time (ms)',[0 2*CycDur*1.001]);
X = cell(1,Nsub);
Y = cell(1,Nsub);

% various defaults, set lin/log, disable menu items, set limits, etc
set(figh, 'menubar', 'none');
set(hh.BinMenu, 'enable', 'off');

