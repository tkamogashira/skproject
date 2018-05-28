function [varargout] = UCpst(keyword, varargin);
% UCPST - post-stimulus histogram
%     [H, R] = UCpst(DS) plots post-stimulus histograms for all conditions.
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
Yunit = 'Spikes';
PoolSubseqs = 0;
TimeWindow = 'repdur';
params = CollectInStruct(iSub, iRep, Ymax, Yunit, Nbin, TimeWindow, PoolSubseqs);


function PST = localComputeIt(ds, params);
ds = fillDataset(ds); % make sure that ds contains data
PST.params = params;
PST.DSinfo = emptyDataSet(ds); % remove data, keep the rest
iSub = ExpandIsub(params.iSub, ds);
TW = expandTimeWindow(params.TimeWindow, ds);
PST.xlim = [TW];
PST.timeWindow = TW;
PST.iSub = iSub;
SPT = Anwin(ds.spt, TW, params.iRep); % select spikes within TW
NrepProc = size(SPT,2); % # reps processed; this anticipates limited selections of reps @ AnWin call above
PST.MaxY = 1e-14;
PST.hist = [];
for isub = iSub,
   spt = cat(2, SPT{isub,:}); % pool all reps
   totNspike = length(spt); % total spike count of this subseq
   totNspikePerRep = totNspike/NrepProc; 
   avSpikeRate = 1e3*totNspikePerRep/diff(TW); % 1e3 because TW is in ms
   Edges = linspace(TW(1), TW(2), params.Nbin+1); binwidth = Edges(2)-Edges(1);
   if isempty(spt), spt = inf; end; % avoid crash dump but still use histc
   N = histc(spt, Edges); N = N(1:end-1); % remove last garbage bin
   Rate = N*1e3/binwidth/ds.nrep(1); Ncyc = NaN; 
   NperRep = N/NrepProc;
   hist = collectInStruct(isub, N, Rate, NperRep, Edges, binwidth, Ncyc, ...
      totNspike, totNspikePerRep, avSpikeRate);
   PST.hist = [PST.hist hist];
   PST.MaxY = max(PST.MaxY, max(hist.N));
end
if params.PoolSubseqs, % contract indiv histograms to single grand hist
   hist = PST.hist(1); hist.N = 0; hist.Rate = 0; 
   Nhist = length(PST.hist);
   for ihist = 1:Nhist,
      hist.N = hist.N + PST.hist(ihist).N;
      hist.Rate = hist.Rate + PST.hist(ihist).Rate/Nhist;
   end
   PST.hist = hist;
end
PST.MaxN = max([PST.hist.N]); PST.MaxRate = max([PST.hist.Rate]);
PST.plotfnc = mfilename;

function figh = localPlotIt(PST, figh);
% public(PST);
RateInfo = localRateInfo(PST); % compile spike count info
% call standard histo plotter 
[figh, ds, params, ymax, LegendIndex] = ...
   dataplotHist(PST, figh, mfilename,'Time (ms)', 1, RateInfo); % 5th arg: do plot burstdur
% store plot-determining params in figure itself so that it is self-supporting
StoreInDataPlot(figh, ds, params, mfilename, ymax); % passing ymax is inelegant but needed for splitting plots
% set figure titlebar 
DataPlotTitleBar(ds, params.iSub, figh);
% put extra info in last, unused, axes so that it can be easily cleared (see above)
[fn seq] = strtok(ds.title); seq = nospace(seq); 
binstr = ['Nbin=' num2sstr(params.Nbin)];
wstr = 'Window: '; TW = params.TimeWindow;
if ischar(params.TimeWindow), wstr = [wstr TW];
else, wstr = [wstr strsubst(num2sstr(TW),' ','..') ' ms']; 
end;
if isequal(0,params.iRep), repstr = 'All reps';
else, repstr = ['Rep: ' num2sstr(params.iRep,1)];
end
legendStr = strvcat('PST histogram', binstr, wstr, repstr);
dh = subplot(LegendIndex{:});
set(dh, 'box', 'on', 'color', 0.9*[1 1 1], 'xtick', [],  'ytick', []);
text(0.5,0.5, legendStr, 'fontsize', 8, 'horizontalalignment', 'center');


function RateInfo = localRateInfo(PST);
% compile spike count info per condition showed
switch PST.params.Yunit,
case 'Spikes', 
   RateInfo = words2cell(num2sstr([PST.hist.totNspike]));
   Unit = 'spikes';
case 'Rate',
   RateInfo = words2cell(num2sstr([PST.hist.avSpikeRate]));
   Unit = 'sp/s';
case 'Spikes/rep',
   RateInfo = words2cell(num2sstr([PST.hist.totNspikePerRep]));
   Unit = 'sp/rep';
end
Nsub = length(PST.hist);
for ii=1:Nsub,
   RateInfo{ii} = [RateInfo{ii} ' ' Unit];
end

