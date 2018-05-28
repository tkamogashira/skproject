function varargout = UCvphase(keyword, varargin);
%  UCvphase - plot of vector strength & phase
%     [H, R] = UCvphase(DS) plots vector strength and phase as a function of
%     the independent variable. 
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
%
%     The actual default value corresponds to the highest priority among
%     existing "particular" frequencies.
%     Closed circles indicate significant phase locking according to an 
%     adjustable Rahleigh criterion. Open circles indicate insignifant phase locking.
%
%     For advanced syntax options, see UCrate.

%=====handling of inputs, outputs, recursive calls is handles by generic ucXXX switchboard script========
callerfnc = mfilename; % needed within switchboard
UCxxxSwitchboard

%=========the real action is handled by local functions below==========
%================================================================

function params = localDefaultParams(iSub);
Nbin = NaN;
iRep = 0;
TimeWindow = 'burstdur';
FcycType = 'auto'; % i.e., fcar or, if mod present, fmod
Chan = 'auto'; % i.e., active channel, beat if binaural & nonzero
RaleighCrit = 0.001; % boundary Raleigh criterion  for significance
compDelay = 0; % ms compensating delay in the plot
Fcyc = 137; % cycle freq: just a number
PhaseConv = 2; % phase convention +1 (-1) means lag = pos (neg)
PhaseUnit = 'cycle'; % phase unit: cycle|rad|deg
params = CollectInStruct(iSub, iRep, Nbin, TimeWindow, FcycType, ...
   Chan, Fcyc, RaleighCrit, compDelay, PhaseConv, PhaseUnit);


function VS_PH = localComputeIt(ds, params);
% VS_PH - VectorStrength/Phase
ds = fillDataset(ds); % make sure that ds contains data
VS_PH.params = params;
VS_PH.DSinfo = emptyDataSet(ds); % remove data, keep the rest
iSub = ExpandIsub(params.iSub, ds);
TW = expandTimeWindow(params.TimeWindow, ds);
VS_PH.timeWindow = TW;
% sort values of indep variable while ignoring NaN's
[xval iSub] = sort(ds.xval);
iok = find(~isnan(xval));
if isequal('BN',ds.stimtype) & ~isequal('other', params.FcycType), % indiv carrier freqs are binning freqs
   BNbuf = prepareBNstim(ds.stimparam);
   Ncar = length(BNbuf.Kfreq);
   VS_PH.Xval = BNbuf.DDfreq*BNbuf.Kfreq(:);
   VS_PH.iSub = ones(Ncar, 1);
   VS_PH.Fcyc = BNbuf.DDfreq*BNbuf.Kfreq(:);
   VS_PH.xlabel = 'Frequency (Hz)';
   VS_PH.compPhase = -angle(BNbuf.EE0);
   fstr = 'Carrier Freq';
else, % subsequences determine binning freq
   VS_PH.Xval = xval(iok);
   VS_PH.iSub = iSub(iok);
   [VS_PH.Fcyc fstr] = ExpandFcycle(params.FcycType, params.Chan, params.Fcyc, ds);
   VS_PH.compPhase = 0*VS_PH.Fcyc;
   fstr = fstr';
   VS_PH.xlabel = ds.xlabel;
end
SPT = AnWin(ds.spt, TW, params.iRep); % select spikes within TW
VS_PH.FcycStr = fstr(:)';
for ii = 1:length(VS_PH.iSub),
   isub = VS_PH.iSub(ii);
   if isequal('BN',ds.stimtype), ifreq = ii; else, ifreq = isub; end;
   spt = cat(2,SPT{isub,:}); % pool spikes of diff reps
   Fcyc = VS_PH.Fcyc(ifreq); % hist freq in Hz
   wrapPeriod = 1e3/Fcyc; % in ms
   Ncyc = abs(diff(TW))/wrapPeriod; % UNrounded number of cycles in analysis window
   [R, alpha] = VectorStrength(spt, Fcyc, TW); % TW is passed for correction of frac # cycles
   VS_PH.VS(ii) = abs(R);
   VS_PH.PhaseRad(ii) = angle(R)-VS_PH.compPhase(ii); % phase in radians
   VS_PH.PhaseDeg(ii) = VS_PH.PhaseRad(ii)/pi*180; % in deg
   VS_PH.PhaseCyc(ii) = VS_PH.PhaseRad(ii)/pi/2; % in cycles
   VS_PH.alpha(ii) = alpha; % Raleigh significance
end
VS_PH.isign = find(VS_PH.alpha<=params.RaleighCrit);
VS_PH.plotfnc = mfilename;
ps = ds.x.PlotScale;
dynrange = max(abs(VS_PH.Xval))/min(1e-14+abs(VS_PH.Xval));
if isequal('log',ps) & dynrange>=10 & all(VS_PH.Xval>0), 
   VS_PH.xScale = 'log';
else, VS_PH.xScale = 'lin';
end
% convert raw phases to plotted phases
phsign = 1; if params.PhaseConv==2, phsign=-1; end; % invert phase sign if the convention asks it
if isequal('BN', ds.stimtype),
   cphase = VS_PH.Xval.'*2*pi*1e-3.*VS_PH.params.compDelay; % phase compensation from delay
else,
   cphase = VS_PH.Fcyc(VS_PH.iSub).'*2*pi*1e-3.*VS_PH.params.compDelay; % phase compensation from delay
end
VS_PH.plotPhaseUnit = params.PhaseUnit;
ph = unwrap(phsign*(VS_PH.PhaseRad-cphase)); 
if isequal('cycle', params.PhaseUnit), ph = ph/2/pi; % RAD -> CYCLE
elseif isequal('deg', params.PhaseUnit), ph = ph/pi*180; % RAD -> DEG
end
ph = ph-round(mean(ph));
VS_PH.PlotPhase = ph;

function figh = localPlotIt(VS_PH, figh);
if nargin<1, figh=-1; end;
DVcomp(VS_PH); % make plotted beauty available from commandline
% find or create figure to plot to
figh = openDataPlot(figh, 'Rateplot', mfilename);
% abbreviations
params = VS_PH.params;
ds = VS_PH.DSinfo;
% ---VS
subplot(3,1,1); LegendIndex  = {3,1,3};
X = VS_PH.Xval;
isig = VS_PH.isign; % indices of Raleigh-significant points
plot(X, VS_PH.VS, '-o', 'MarkerFaceColor', [1 1 1]); hold on;
plot(X(isig), VS_PH.VS(isig), '-o', 'MarkerFaceColor', [0 0 1]);
set(gca,'Xscale', VS_PH.xScale); % log vs lin
ylim([0 1]);
ylabel('Vector strength');
% ---PH
ds = VS_PH.DSinfo;
subplot(3,1,2);
ph = VS_PH.PlotPhase;
plot(X, ph, '-o', 'MarkerFaceColor', [1 1 1]); hold on;
plot(X(isig), ph(isig), '-o', 'MarkerFaceColor', [0 0 1]);
set(gca,'Xscale', VS_PH.xScale); % log vs lin
xlabel(VS_PH.xlabel);
phaseStr = 'lag'; if VS_PH.params.PhaseConv==2, phaseStr = 'lead'; end;
ylabel(['Phase ' phaseStr ' (' VS_PH.plotPhaseUnit  ')']);

% title contains stimulus info
subplot(3,1,1);
bd = ds.burstdur;
if (length(bd)>1) & (diff(bd)==0), bd = bd(1); end;
titstr = [ds.title ' --- ' ds.pres , ' --- burst: ' num2sstr(bd) ' ms'];
Th = title(titstr); 
% store plot-determining params in figure itself so that it is self-supporting
StoreInDataPlot(figh, ds, params, mfilename); 
% set figure titlebar 
DataPlotTitleBar(ds, 0, figh);
% put extra info in last, unused, axes so that it can be easily cleared (see above)
wstr = 'Window: '; TW = params.TimeWindow;
if ischar(params.TimeWindow), wstr = [wstr TW];
else, wstr = [wstr strsubst(num2sstr(TW),' ','..') ' ms']; 
end;
FcycStr = ['Wrap freq: ', VS_PH.FcycStr];
RalStr = ['Rayleigh criterion: ', num2sstr(VS_PH.params.RaleighCrit)];
cdStr = ['Compensating delay: ', num2sstr(VS_PH.params.compDelay), ' ms; ' '\phi > 0 \rightarrow ' phaseStr];
if isequal(0,params.iRep), repstr = 'All reps';
else, repstr = ['Rep: ' num2sstr(params.iRep,1)];
end
wstr = [wstr '      ' repstr];
legendStr = strvcat('Vector strength & Phase of component @ wrap freq', wstr, FcycStr, RalStr, cdStr);
dh = subplot(LegendIndex{:});
dpos = get(dh,'position');
set(dh, 'box', 'on', 'color', 0.9*[1 1 1], 'xtick', [],  'ytick', [], 'position', dpos.*[1 1 1 0.8]);
text(0.5,0.5, legendStr, 'fontsize', 8, 'horizontalalignment', 'center');
