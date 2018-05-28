function varargout = UCthr(keyword, varargin);
% UCthr - THR curve
%   [H, R] = UCthr(DS) plots the threshold plot in dataset DS.
%   H is the figure handle and R is a struct containing the results as plotted.
%   The figure contains pull-down menus for interactive adjustments of the 
%   analysis parameters.
%
%   see also THRPLOT.

%=====handling of inputs, outputs, recursive calls is handles by generic ucXXX switchboard script========
callerfnc = mfilename; % needed within switchboard
UCxxxSwitchboard

%=========the real action is handled by local functions below==========
%================================================================


function params = localDefaultParams(iSub, figh);
iSub = nan; % N/A
Xscale = 'lin'; % log/lin depending on freq span
Xunit = 'auto';  % Hz if max freq < 1000, kHz otherwise
Ymin = 'auto'; % equal to min SPL of THR run
Ymax = 'auto'; % equal to max SPL of THR run
params = CollectInStruct(iSub, Xscale, Xunit, Ymin, Ymax);

function THR = localComputeIt(ds, params);
% get the data , compute spot rate and store the bookkeeping stuff
THR.params = params;
THR.DSinfo = emptyDataset(ds);
THR.iSub = [];
ds = fillDataset(ds);
TC = ds.data.OtherData.thrCurve;
THR.Freq = TC.freq;
THR.Thr = TC.threshold;
[THR.CF, THR.minThr] = minloc(THR.Freq, THR.Thr); % (freq of) minimum thr
[THR.Ymin, THR.Ymax] = deal(params.Ymin, params.Ymax);
if isequal('auto', THR.Ymin), THR.Ymin = ds.minSPL; end
if isequal('auto', THR.Ymax), THR.Ymax = ds.SPL; end
[THR.Xscale, THR.Xunit] = deal(params.Xscale, params.Xunit);
if isequal('auto', THR.Xunit), % decide based on freq range
   if max(THR.Freq>1000), THR.Xunit = 'kHz';
   else, THR.Xunit = 'Hz';
   end
end
if isequal('auto', THR.Xscale),
   if (max(THR.Freq)/min(THR.Freq))>2, THR.Xscale = 'log';
   else, THR.Xscale = 'lin';
   end
end


% spont rate
ds = fillDataset(ds);
NN = length(ds.spt); % # virtual bursts in silent interval
SPT = ds.spt; Nspike = length(cat(2,SPT{1,:}));
THR.SpontRate = Nspike/(NN*ds.burstdur*1e-3);
THR.plotfnc = mfilename;
   
function figh = localPlotIt(THR, figh);
if nargin<1, figh=-1; end;
DVcomp(THR); % make plotted beauty available from commandline
% find or create figure to plot to
figh = openDataPlot(figh, 'THRplot', mfilename);
set(figh, 'ResizeFcn', '');
% abbreviations
params = THR.params;
ds = THR.DSinfo;
if isequal('kHz', THR.Xunit), fscale = 1e-3; else, fscale = 1; end
plot(fscale*THR.Freq, THR.Thr, '-o', fscale*THR.CF, THR.minThr, '*r');
set(gca,'pos',[0.13 0.13 0.75 0.7], 'Xscale', THR.Xscale);
xlabel(['Frequency (' THR.Xunit ')']);
ylim([THR.Ymin, THR.Ymax]);
ylabel('Threshold (dB SPL)');
% store plot-determining params in figure itself so that it is self-supporting
StoreInDataPlot(figh, ds, params, mfilename); 
% set figure titlebar 
DataPlotTitleBar(ds, 0, figh);
% title
IDstr = [ds.title ' (' num2str(ds.iSeq) ') '];
mint = 0.1*round(10*THR.minThr);
minf = 0.001*round(THR.CF); % Hz -> kHz
CFstr = [num2str(mint) ' dB SPL @ ' num2str(minf,4) ' kHz  SR = ' num2sstr(THR.SpontRate,3) ' sp/s'];
title(strvcat(IDstr, CFstr)); 
% report = ['% ' num2str(ds.iseq) ' --- cell ' num2str(DS.icell) ' -- ' CFstr '   <' DS.SeqID '>'];





