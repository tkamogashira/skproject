function [varargout] = UCcyc(keyword, varargin);
% UCcyc - cycle histogram
%     [H, R] = UCcyc(DS) plots cycle histograms for all conditions.
%     H is the figure handle and R is a struct containing the results as plotted.
%     The figure contains pull-down menus for interactive adjustments of the 
%     analysis parameters.
%
%     The wrap frequency can be either a given constant or certain 
%     frequencies particular to the stimulus: carrier (left/right/binbeat)
%     or modulation (left/right/binbeat). The default wrap frequency is the
%     chosen according to the following relative priorities (decreasing):
%       binbeat > left or right
%       modulation > carrier
%     The actual default value corresponds to the highest priority among
%     existing "particular" frequencies.
%
%     For advanced syntax options, see UCrate.


%=====handling of inputs, outputs, recursive calls is handles by generic ucXXX switchboard script========
callerfnc = mfilename; % needed within switchboard
UCxxxSwitchboard

%=========the real action is handled by local functions below==========


function params = localDefaultParams(iSub, figh);
Nbin = 50;
iRep = 0;
Ymax = 'auto';
Yunit = 'Spikes';
TimeWindow = 'burstdur';
FcycType = 'auto'; % i.e., fcar or, if mod present, fmod
Chan = 'auto'; % i.e., active channel, beat if binaural & nonzero
Fcyc = 100; % just a number
params = CollectInStruct(iSub, iRep, Ymax, Yunit, Nbin, TimeWindow, FcycType, Chan, Fcyc);

function CYC = localComputeIt(ds, params);
ds = fillDataset(ds); % make sure that ds contains data
CYC.params = params;
CYC.DSinfo = emptyDataSet(ds); % remove data, keep the rest
iSub = ExpandIsub(params.iSub, ds);
TW = expandTimeWindow(params.TimeWindow, ds);
CYC.xlim = [0 1]; % cycles
CYC.timeWindow = TW;
CYC.iSub = iSub;
SPT = AnWin(ds.spt, TW, params.iRep);  % select spikes within TW
NrepProc = size(SPT,2); % # reps processed; respect limited selections of reps @ AnWin call above
CYC.hist = [];
[CYC.Fcyc CYC.FcycStr] = ExpandFcycle(params.FcycType, params.Chan, params.Fcyc, ds);
for isub = iSub,
   spt = cat(2, SPT{isub,:});
   % spt = spt(find((spt>=TW(1))&(spt<TW(end))));
   QQQ = CYC.Fcyc;
   Fcyc = CYC.Fcyc(isub); % hist freq in Hz
   wrapPeriod = 1e3/Fcyc; % in ms
   Ncyc = abs(diff(TW))/wrapPeriod; % UNrounded number of cycles in analysis window
   spt = rem(spt, wrapPeriod)/wrapPeriod; % wrap spt & convert them to phase re Fcycle
   Edges = linspace(0, 1, params.Nbin+1); 
   binwidth = Edges(2)-Edges(1); % in cycles!
   if isempty(spt), spt = inf; end; % avoid crash dump but still use histc
   N = histc(spt, Edges); N = N(1:end-1); % remove last garbage bin
   % correct for non-integer Ncyc
   binPhase = linspace(binwidth/2, 1-binwidth/2, params.Nbin); % phases of bin centers
   startPhase = rem(TW(1)/wrapPeriod,1); % phase in cycles at start of analysis window
   FracWeight = FracCycleWeight(binPhase, startPhase, Ncyc);
   N = N.*FracWeight;
   NperRep = N/NrepProc;
   binDur = binwidth*wrapPeriod*1e-3; % binwidth in s
   Rate = N/ds.nrep(1)/Ncyc/binDur; 
   hist = collectInStruct(isub, N, NperRep, Rate, Edges, binwidth, Fcyc, Ncyc, binDur, FracWeight);
   CYC.hist = [CYC.hist hist];
end
CYC.plotfnc = mfilename;

function figh = localPlotIt(CYC, figh);
% call standard histo plotter 
[figh, ds, params, ymax, LegendIndex] ...
   = dataplotHist(CYC, figh, mfilename, 'Phase (cyc)');
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
if isequal(0,params.iRep), repstr = 'All reps';
else, repstr = ['Rep: ' num2sstr(params.iRep,1)];
end
FcycStr = strvcat('hist freq:', CYC.FcycStr);
legendStr = strvcat('Cycle histogram', binstr, wstr, FcycStr,repstr);
dh = subplot(LegendIndex{:});
text(0.5,0.5, legendStr, 'fontsize', 8, 'horizontalalignment', 'center');

