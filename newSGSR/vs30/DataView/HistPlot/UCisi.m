function [varargout] = UCisi(keyword, varargin)
% UCISI - all -order inter-spike interval statistics
%     [H, R] = UCisi(DS) plots all-order inter-spike histograms for all conditions.
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
function params = localDefaultParams(iSub, figh)
Nbin = 50;
iRep = 0;
Ymax = 'auto';
YmaxFactor = 1.3; % need space for 2 lines of text
Yunit = 'Spikes';
TimeWindow = 'repdur'; 
DiffOrder = 1;
MaxIsi = 50; % ms max isi considered in histo
params = CollectInStruct(iSub, iRep, Ymax, YmaxFactor, Yunit, Nbin, TimeWindow, MaxIsi, DiffOrder);

function ISI = localComputeIt(ds, params)
ds = fillDataset(ds); % make sure that ds contains data
ISI.params = params;
ISI.DSinfo = emptyDataSet(ds); % remove data, keep the rest
iSub = ExpandIsub(params.iSub, ds);
TW = expandTimeWindow(params.TimeWindow, ds);
Nord = params.DiffOrder; % order of the differences
maxISI = Nord*params.MaxIsi; % maxISI as stored is per 1st-order. x-range is sacled with order
ISI.xlim = [0 maxISI];
ISI.timeWindow = TW;
ISI.iSub = iSub;
SPT = Anwin(ds.spt, TW, params.iRep); % select spikes within TW
NrepProc = size(SPT,2); % # reps processed; limited selections of reps @ AnWin call above
ISI.MaxY = 1e-14;
ISI.hist = [];
for isub = iSub,
   dspt = [];
   for irep=1:size(SPT,2),
      spt = SPT{isub,irep};
      dspt = [dspt ndiff(spt, Nord)]; % nth-order spike time differences
   end
   Nint = length(dspt); % # intervals in histogram
   warningState off; % suppress warnings on empty dspt
   MeanInt = mean(dspt); % mean of interval distribution
   StdInt = std(dspt); % std of interval distribution
   warningState restore;
   Edges = linspace(0, maxISI, params.Nbin+1);  binwidth = Edges(2)-Edges(1);
   if isempty(dspt), dspt = inf; end; % avoid crash dump but still use histc
   N = histc(dspt, Edges); N = N(1:end-1); % remove last garbage bin
   Rate = N*1e3/binwidth/ds.nrep(1); Ncyc = NaN; 
   hist = collectInStruct(isub, N, Rate, Edges, binwidth, Ncyc, Nint, MeanInt, StdInt);
   ISI.hist = [ISI.hist hist];
   ISI.MaxY = max(ISI.MaxY, max(hist.N));
end
ISI.MaxY = max(1,ISI.MaxY); % avoid trivial errors if all plots are empty
ISI.MaxN = max([ISI.hist.N]); ISI.MaxRate = max([ISI.hist.Rate]);
ISI.plotfnc = mfilename;

function figh = localPlotIt(ISI, figh)
Stats = localStats(ISI); % stats like # intervals, mean, std
% call standard histo plotter 
[figh, ds, params, ymax, LegendIndex] ...
   = dataplotHist(ISI, figh, mfilename, 'ISI (ms)', 0, Stats); % 0: no grey line @ burst offset
% store plot-determining params in figure itself so that it is self-supporting
StoreInDataPlot(figh, ds, params, mfilename, ymax); % passing ymax is inelegant but needed for splitting plots
% set figure titlebar 
DataPlotTitleBar(ds, params.iSub, figh);
binstr = ['Nbin=' num2sstr(params.Nbin)];
wstr = 'Window: '; TW = params.TimeWindow;
if ischar(params.TimeWindow), wstr = [wstr TW];
else wstr = [wstr num2sstr(TW) ' ms']; 
end;
if isequal(0,params.iRep), repstr = 'All reps';
else repstr = ['Rep: ' num2sstr(params.iRep,1)];
end
orderStr = ['Diff order=' num2sstr(params.DiffOrder)];
legendStr = strvcat('Inter-spike int.', binstr, wstr, orderStr, repstr);
dh = subplot(LegendIndex{:});
text(0.5,0.5, legendStr, 'fontsize', 8, 'horizontalalignment', 'center');

function Stats = localStats(ISI)
% compile spike count info per condition showed
NintStr = words2cell(num2sstr([ISI.hist.Nint]));
MeanStr = words2cell(num2sstr([ISI.hist.MeanInt]));
StdStr = words2cell(num2sstr([ISI.hist.StdInt]));
Nsub = length(ISI.hist);
for ii=1:Nsub,
   line0 = ['?: ' NintStr{ii} ' intv']; % heading '?' means: append to subseq title, see dataPlotHist
   stdstr = StdStr{ii}(1:min(end,3)); 
   line1 = ['Mn: ' MeanStr{ii} ' (' stdstr  ') ms'];
   Stats{ii} = strvcat(line0, line1);
end
