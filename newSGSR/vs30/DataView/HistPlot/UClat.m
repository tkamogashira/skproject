function [varargout] = UClat(keyword, varargin);
% UCLAT - first-spike latency
%     [H, R] = UClat(DS) plots first-spike latency histograms for all conditions.
%     H is the figure handle and R is a struct containing the results as plotted.
%     The figure contains pull-down menus for interactive adjustments of the 
%     analysis parameters.
%
%     For advanced syntax options, see UCrate.

%=====handling of inputs, outputs, recursive calls is handles by generic ucXXX switchboard script========
callerfnc = mfilename; % needed within switchboard
UCxxxSwitchboard

%=========the real action is handled by local functions below==========

%================================================================
function params = localDefaultParams(iSub, figh);
Nbin = 50;
iRep = 0;
Ymax = 'auto';
YmaxFactor = 1.6; % need lot of space for 3 lines of text
Yunit = 'Spikes';
TimeWindow = 75; % ms max latency
params = CollectInStruct(iSub, iRep, Ymax, YmaxFactor, Yunit, Nbin, TimeWindow);

function LAT = localComputeIt(ds, params);
ds = fillDataset(ds); % make sure that ds contains data
LAT.params = params;
LAT.DSinfo = emptyDataSet(ds); % remove data, keep the rest
iSub = ExpandIsub(params.iSub, ds);
TW = expandTimeWindow(params.TimeWindow, ds);
LAT.xlim = TW;
LAT.timeWindow = TW;
LAT.iSub = iSub;
SPT = ds.spt; LAT.MaxY = 1e-14;
LAT.hist = [];
RepSelect = params.iRep(:).'; if isequal(0,RepSelect), RepSelect = 1:1:ds.Nrep; end
for isub = iSub,
   first = [];
   for irep=RepSelect;
      spt = AnWin(SPT{isub,irep}, TW);  % select spikes within TW
      if length(spt)>0, first = [first spt(1)]; end
   end
   Edges = linspace(TW(1), TW(2), params.Nbin+1); binwidth = Edges(2)-Edges(1);
   totN = length(first); % number of spikes in histogram
   if isempty(first), first = inf; end; % avoid crash dump but still use histc
   [LatMean, LatStd, LatMed, LatSIQR] = deal(mean(first), std(first), median(first), iqr(first)/2);
   N = histc(first, Edges); N = N(1:end-1); % remove last garbage bin
   Rate = nan; Ncyc = NaN; 
   hist = collectInStruct(isub, N, Rate, Edges, binwidth, Ncyc, totN, LatMean, LatStd, LatMed, LatSIQR);
   LAT.hist = [LAT.hist hist];
end
LAT.MaxN = max([LAT.hist.N]); LAT.MaxRate = max([LAT.hist.Rate]);
LAT.plotfnc = mfilename;

function figh = localPlotIt(LAT, figh);
Stats = localStats(LAT); % stats like # spikes, mean, std
% call standard histo plotter 
[figh, ds, params, ymax, LegendIndex] ...
   = dataplotHist(LAT, figh, mfilename, 'Latency (ms)', 0, Stats); % 0: no grey line @ burst offset
% store plot-determining params in figure itself so that it is self-supporting
StoreInDataPlot(figh, ds, params, mfilename, ymax); % passing ymax is inelegant but needed for splitting plots
% set figure titlebar 
DataPlotTitleBar(ds, params.iSub, figh);
binstr = ['Nbin=' num2sstr(params.Nbin)];
wstr = 'Window: '; TW = params.TimeWindow;
if ischar(params.TimeWindow), wstr = [wstr TW];
else, wstr = [wstr num2sstr(TW) ' ms']; 
end;
if isequal(0,params.iRep), repstr = 'All reps';
else, repstr = ['Rep: ' num2sstr(params.iRep,1)];
end
legendStr = strvcat('1st-sp. latency', binstr, wstr, repstr);
dh = subplot(LegendIndex{:});
text(0.5,0.5, legendStr, 'fontsize', 8, 'horizontalalignment', 'center');

function Stats = localStats(LAT);
% compile spike count info per condition showed
NspikeStr = words2cell(num2sstr([LAT.hist.totN]));
MeanStr = words2cell(num2sstr([LAT.hist.LatMean]));
StdStr = words2cell(num2sstr([LAT.hist.LatStd]));
MedStr = words2cell(num2sstr([LAT.hist.LatMed]));
IqStr = words2cell(num2sstr([LAT.hist.LatSIQR]));
Nsub = length(LAT.hist);
for ii=1:Nsub,
   line0 = ['?: ' NspikeStr{ii} ' sp']; % heading '?' means: append to subseq title, see dataPlotHist
   stdstr = StdStr{ii}(1:min(end,3)); 
   line1 = ['Mn: ' MeanStr{ii} ' (' stdstr  ')'];
   iqstr = IqStr{ii}(1:min(end,3)); 
   line2 = ['Med:' MedStr{ii} ' (' iqstr  ')'];
   Stats{ii} = strvcat(line0, line1, line2);
end








