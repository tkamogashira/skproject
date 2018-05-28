function [varargout] = UCsync(keyword, varargin);
% UCSYBC - sync/phase plot
%   usage: UCSYNC(DS, ISUB)

if nargin<1, % callback from menu
   keyword = get(gcbo, 'tag');
   if isempty(keyword), keyword = curDS; end; % lazy syntax for debugging
end
% fill non-existent varargins with []
for ii=max(1,nargin):100, varargin{ii} = []; end

if isa(keyword,'dataset'),
   ds = keyword;
   keyword = 'newplot';
end

switch keyword,
case 'newplot', % [FIGH, SYNC] = UCSYNC(DS, ISUB, FIGH, PROP1, VAL1, ...)
   [iSub figh]= deal(varargin{1:2});
   if isempty(iSub), iSub=0; end; % iSub=0 means: all subs
   params = localGetParams(ds, iSub, varargin{3:end}); % retrieve params for SYNC plot
   SYNC = UCsync('compute', ds, params, 0);
   figh = UCsync('plot', SYNC, figh);
   [varargout{1:2}] = deal(figh, SYNC);
case 'compute', % [SYNC FIGH] = UCSYNC(DS, PARAMS, FIGH)
   [ds, params, figh] =  deal(varargin{1:3});
   if isempty(params), params = localGetParams(ds,0); end;%default values for this dataset
   doplot = ~isequal(0,figh);
   SYNC = localComputeSYNC(ds, params);
   if doplot, figh = UCsync('plot', SYNC, figh); end;
   [varargout{1:2}] = deal(SYNC, figh);
case 'params', % [PARAMS] = UCSYNC 'PARAMS' DS ISUB PROP1 VAL1 ..
   [ds, iSub]= deal(varargin{1:2});
   if isempty(iSub), iSub=0; end; % iSub=0 means: all subs
   params = localGetParams(ds, iSub, varargin{3:end}); % retrieve params for SYNC plot
   varargout{1} = params;
case 'defaultparams', % [PARAMS] = UCSYNC('DEFAULTPARAMS')
   params = localDefaultParams(0);
   varargout{1} = params;
case 'plot', % [FIGH SYNC] = UCSYNC 'PLOT' SYNC FIGH
   [SYNC, figh] =  deal(varargin{1:2});
   figh = localPlotSYNC(SYNC, figh);
   [varargout{1:2}] = deal(figh, SYNC);
otherwise, % deal with standard set of keywords
   OK = StandardDataPlotFunctions(keyword, gcf, gcbf);
   if ~OK, error(['Unknown keyword ''' keyword '''']); end;
end

%================================================================
function params = localGetParams(ds, iSub, varargin); % retrieve params for SYNC plot
params = localDefaultParams(iSub);
CFN = DataPlotCacheFile(ds.filename, mfilename); % cache file for params
CachePar = DataPlotCachePar(ds, params); % determinant of cache entry
params = GetDataViewParams(params, CFN, CachePar, varargin{:});

function params = localDefaultParams(iSub, figh);
Nbin = 50;
Ymax = 'auto';
Yunit = 'Spikes';
TimeWindow = 'burstdur';
FsyncType = 'auto'; % i.e., fcar or, if mod present, fmod
Chan = 'auto'; % i.e., active channel, beat if binaural & nonzero
Fsync = 100; % just a number
params = CollectInStruct(iSub, Ymax, Yunit, Nbin, TimeWindow, FsyncType, Chan, Fsync);

function figh = localPlotSYNC(SYNC, figh);
% call standard histo plotter 
[figh, ds, params, ymax, LegendIndex] ...
   = dataplotHist(SYNC, figh, mfilename, 'Phase (sync)');
% store plot-determining params in figure itself so that it is self-supporting
% note: passing ymax is inelegant but needed for splitting plots
StoreInDataPlot(figh, ds, params, mfilename, ymax); 
% set figure titlebar 
DataPlotTitleBar(ds, params.iSub, figh);
% put extra info in last, unused, axes so that it can be easily cleared (see above)
binstr = ['Nbin=' num2sstr(params.Nbin)];
wstr = 'Window: '; TW = params.TimeWindow;
if ischar(params.TimeWindow), wstr = [wstr TW];
else, wstr = [wstr strsubst(num2sstr(TW),' ','...') ' ms']; 
end;
FsyncStr = strvcat('hist freq:', SYNC.FsyncStr);
legendStr = strvcat('syncle histogram', binstr, wstr, FsyncStr);
dh = subplot(LegendIndex{:});
text(0.5,0.5, legendStr, 'fontsize', 8, 'horizontalalignment', 'center');

function SYNC = localComputeSYNC(ds, params);
ds = fillDataset(ds); % make sure that ds contains data
SYNC.params = params;
SYNC.DSinfo = emptyDataSet(ds); % remove data, keep the rest
iSub = ExpandIsub(params.iSub, ds);
TW = expandTimeWindow(params.TimeWindow, ds);
SYNC.xlim = [0 1]; % syncles
SYNC.timeWindow = TW;
SYNC.iSub = iSub;
SPT = ds.spt; 
SYNC.hist = [];
[SYNC.Fsync SYNC.FsyncStr] = ExpandFsyncle(params.FsyncType, params.Chan, params.Fsync, ds);
for isub = iSub,
   spt = cat(2, SPT{isub,:});
   spt = spt(find((spt>=TW(1))&(spt<TW(end)))); % select spikes within TW
   Fsync = SYNC.Fsync(isub); % hist freq in Hz
   wrapPeriod = 1e3/Fsync; % in ms
   Nsync = abs(diff(TW))/wrapPeriod; % number of syncles in analysis window
   spt = rem(spt, wrapPeriod)/wrapPeriod; % wrap spt & convert them to phase re Fsyncle
   Edges = linspace(0, 1, params.Nbin+1); 
   binwidth = Edges(2)-Edges(1); % in syncles!
   if isempty(spt), spt = inf; end; % avoid crash dump but still use histc
   N = histc(spt, Edges); N = N(1:end-1); % remove last garbage bin
   binDur = binwidth*wrapPeriod*1e-3; % binwidth in s
   Rate = N/ds.nrep(1)/Nsync/binDur; 
   hist = collectInStruct(isub, N, Rate, Edges, binwidth, Fsync, Nsync, binDur);
   SYNC.hist = [SYNC.hist hist];
end
SYNC.plotfnc = mfilename;
% store params used for this computation (note: do not store computation itself!)
CFN = DataPlotCacheFile(ds.filename, mfilename); % cache file for params
CachePar = DataPlotCachePar(ds, params); % determinant of cache entry
ToCacheFile(CFN, -2e3, CachePar, params);

