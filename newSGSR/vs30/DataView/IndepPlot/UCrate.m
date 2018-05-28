function varargout = UCrate(keyword, varargin)
%  UCrate - rate plot
%     [h, R] = UCrate(DS) plots rate plot of dataset DS to a new figure.
%     H is the figure handle and R is a struct containing the results as plotted.
%     The figure contains pull-down menus for interactive adjustments of the 
%     analysis parameters.
%
%     ----------ADVANCED SYNTAX-----------
%     Note: the syntaxes below are valid for *all* ucXXX functions except ucRas.
%
%     UCrate(DS, iSeq) only uses the sequences in vector Iseq. The default
%     is Iseq=0 which means All Sequences.
%
%     UCrate(DS, iSeq, h) plots to existing figure with handle h.
%        
%     UCrate(DS, iSeq, h, P) uses a non-standard set of parameter values in
%     a struct P as returned by the 'factory' and 'params' calls described below.
%     UCrate(DS, iSeq, h, prop, val, ...) is a different syntax to do the same thing.
%     
%     P = UCrate('factory') returns the factory defaults of the 
%     analysis parameters in a struct P.
%
%     P = UCrate('defaults') returns the current default values of the 
%     analysis parameters in a struct P.
%
%     P = UCrate('params', DS, iSub) returns the default parameters of the UCrate
%     analysis for the given stimulus type (DS.stimtype) in a struct P.
%     P = UCrate('params', DS, iSub, prop, val, ...) returns a version
%     of the parameters in which the specified prop/val pairs override 
%     the default values for dataset DS.
%     Example: UCrate('params', DS, 'TimeWindow', 'repdur') uses a TimeWindow
%              of repdur instead of the default burstdur.
%
%     R=UCrate('compute', ds, iSub, params) and UCrate('compute', ds, iSub, prop, val, ...)
%     computes the rate function and returns the results in a struct. The results
%     are not plotted. The iSub and subsequent args are optional.
%     
%     UCrate('plot', h, R) plots the results (see previous item) to figure with handle h.
%     If h is not a valid handle or absent, a new figure is opened. 
%     R defaults to UCrate('compute', ds); see previous item.
%     UCrate('plot', figh, ds, ....) first computes the results as in
%     R = UCrate('compute', ds, ....) and then plots them.
%
%     See also UCpst, UClat, UCisi, UCcyc, UCvphase, UCras.


%=====handling of inputs, outputs, recursive calls is handles by generic ucXXX switchboard script========
callerfnc = mfilename; % needed within switchboard
UCxxxSwitchboard

%=========the real action is handled by local functions below==========

function params = localDefaultParams(iSub)
% return factory default values of parameters.
% This is also a declaration of all valid fields of the params struct
% see UCxxxSwitchboard and getDataViewParams
Nbin = NaN;
iRep = 0;
Yunit = 'Rate';
Ymax = 'auto';
TimeWindow = 'burstdur';
params = CollectInStruct(iSub, iRep, Ymax, Yunit, Nbin, TimeWindow);

function RAT = localComputeIt(ds, params)
% compute rate and spike count for each condition
ds = fillDataset(ds); % make sure that ds contains data
RAT.params = params;
RAT.DSinfo = emptyDataSet(ds); % remove data, keep the rest
iSub = ExpandIsub(params.iSub, ds);
TW = expandTimeWindow(params.TimeWindow, ds);
RAT.timeWindow = TW;
% sort values of indep variable
xval = ds.xval(iSub).';
[RAT.Xval idum] = sort(xval);
RAT.iSub = iSub(idum);
SPT = AnWin(ds.spt, TW, params.iRep);  % select spikes within TW
NrepProc = size(SPT,2); % # reps processed; this respects limited selections of reps @ AnWin call above
for ii = 1:length(RAT.iSub),
   isub = RAT.iSub(ii);
   spt = cat(2,SPT{isub,:});
   % spt = spt(find((spt>=TW(1))&(spt<TW(end))));
   RAT.Nspike(ii) = length(spt);
   RAT.NspikePerRep(ii) = length(spt)/NrepProc;
   RAT.Rate(ii) = RAT.Nspike(ii)*1e3/diff(TW)/NrepProc;
end
RAT.plotfnc = mfilename;
ps = ds.x.PlotScale;
dynrange = max(abs(RAT.Xval))/min(1e-14+abs(RAT.Xval));
if isequal('log',ps) && dynrange>=10 && all(RAT.Xval>0), 
    RAT.xScale = 'log';
else
    RAT.xScale = 'lin';
end

function figh = localPlotIt(RAT, figh)
if nargin<1, figh=-1; end;
DVcomp(RAT); % make plotted beauty available from commandline
% find or create figure to plot to
figh = openDataPlot(figh, 'Rateplot', mfilename);

params = RAT.params;
subplot(2,1,1); LegendIndex  = {2,1,2};
if isequal('Spikes', params.Yunit),
   Y = RAT.Nspike;
   YLS = 'Spike count';
elseif isequal('Spikes/rep', params.Yunit),
   Y = RAT.NspikePerRep;
   YLS = 'Spikes/rep';
elseif isequal('Rate', params.Yunit),
   Y = RAT.Rate;
   YLS = 'Spikes/s';
end
plot(RAT.Xval, Y, '-*');
set(gca,'Xscale', RAT.xScale); % log vs lin
ds = RAT.DSinfo;
xlabel(ds.xlabel); ylabel(YLS);
YL = ylim; % default: automatic Ymax
if isnumeric(params.Ymax),
   YL(2) = params.Ymax;
end
ylim([0 YL(2)]);
% title contains stimulus info
bd = ds.burstdur;
if (length(bd)>1) && (diff(bd)==0), bd = bd(1); end;
titstr = [ds.title ' --- ' ds.pres , ' --- burst: ' num2sstr(bd) ' ms'];
Th = title(titstr); 
% store plot-determining params in figure itself so that it is self-supporting
StoreInDataPlot(figh, ds, params, mfilename); 
% set figure titlebar 
DataPlotTitleBar(ds, 0, figh);
% put extra info in last, unused, axes so that it can be easily cleared (see above)
wstr = 'Window: '; TW = params.TimeWindow;
if ischar(params.TimeWindow), wstr = [wstr TW];
else wstr = [wstr strsubst(num2sstr(TW),' ','..') ' ms']; 
end;
if isequal(0,params.iRep), repstr = 'All reps';
else repstr = ['Rep: ' num2sstr(params.iRep,1)];
end
legendStr = strvcat('Rate plot', wstr, repstr);
dh = subplot(LegendIndex{:});
set(dh, 'box', 'on', 'color', 0.9*[1 1 1], 'xtick', [],  'ytick', []);
text(0.5,0.5, legendStr, 'fontsize', 8, 'horizontalalignment', 'center');
