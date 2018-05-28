function y=ErevModPlot(varargin);

global PRPinstr PRPstatus SPIKES
persistent figh axish datah titleh maxh X Y Nbin
maxY = 50;

%---------INIT-------
if isequal(varargin{1},'init'), % initialize spike rate plot and data
   % figure handle is returned
   [figh axish] = local_initPlot(maxY);
   y = figh;
   if isempty(Nbin), Nbin = PRPinstr.PLOT.Nbin; end
   set(figh, 'name', ['Erev Mod --- ' SeqID(1)]);
   X = PRPinstr.PLOT.varValues;
   Y = X+nan;
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
      if isempty(Spt), Spt = inf; end; % avoid emptiness
      BinWidth = CycDur/Nbin;
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
      MeanCount = mean(SpikeCount)+1e-10;
      SpikeCount = 0.5*(SpikeCount(1:2*Nbin) -  SpikeCount(2*Nbin+1:end));
      Y(isub) = std(SpikeCount)/MeanCount;
   end
   return;
end
%---------BINWIDTH-------
if isequal(varargin{1},'binwidth'), % draw the data and flush
   BW = inputdlg('New # Bins:', 'Specify bin count');
   if isempty(BW), return; end;
   BW = str2num(BW{1});
   if isempty(BW), return; end;
   Nbin = BW(1);
   ErevModPlot(0); % revisited all subseqs and re-sort spikes
   ErevModPlot draw;
   local_title(axish(1), Nbin);
   return;
end
%---------DRAW-------
if isequal(varargin{1},'draw'), % draw the data and flush
   aahh = get(figh,'CurrentAxes');
   if ishandle(aahh),
      axes(aahh);
      line(X,Y,'linestyle','-','marker','o');
   end
   drawnow;
   return;
end
%---------FINISH-------
if isequal(varargin{1},'finish'), % draw all data, flush, and fill in details
   ErevModPlot('draw'); % draw all data 
   % enable default menubar to print etc
   set(figh,'menubar', 'figure');
   BWh = findobj(figh,'tag', 'BinMenu');
   set(BWh, 'enable', 'on');
   local_title(axish(1), Nbin);
   return;
end
%-----------ALL---------------
if isequal(varargin{1},'all'), % all of the above
   ErevModPlot('init',varargin{2:end});
   ErevModPlot(0);
   ErevModPlot('draw');
   ErevModPlot('finish');
   return;
end
%---------CLOSE-------
if isequal(varargin{1},'close'), % close plot window if OK, return OK status
   y = 0; % pessimistic default
   % if stimmenu is busy, Erevplot may not be closed
   if ~StimMenuMayBeClosed, return; end
   SaveMenuDefaults('ErevModPlot');
   delete(figh);
   clear global ErevPlotModMenuStatus
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
h = findobj(0,'tag','ErevPlotMenu'); % 
io = isequal([1 1],size(h));
if nargout>1,
   hh = CollectMenuHandles('ErevModPlot', h);
end
%----------locals--------------------------
function local_title(ah, NB);
axes(ah); % title placement
title([SeqID(1) ' --- Erev Mod Depth Plot; # bins = ' num2str(NB) ]);

%------------------------------------------------------
function [figh, axish] = local_initPlot(maxY);
persistent hh
global PRPinstr
CycDur = PRPinstr.PLOT.CycleDur;
[IsOpen hh] = local_IsOpen;
if ~IsOpen, % open new one
   hh = openUImenu('ErevModPlot');
end;
figh = hh.Root;
figure(figh);
axish = gca;
xlabel(PRPinstr.PLOT.xlabel);
ylabel('mod depth of response');

% various defaults, set lin/log, disable menu items, set limits, etc
set(figh, 'menubar', 'none');
set(hh.BinMenu, 'enable', 'off');

