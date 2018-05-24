function T = evalSync2(ds,  varargin)

%% process params
% define structure of parameters: just fill with defaults
params.anWin = 'burstdur';

% Parameters given as arguments are placed in the params structure.
% Other entries remain 'def'. This def value is replaced when plotting.
paramsIn = varargin;
params = processParams(paramsIn, params);


defaultPage;

% Some constants
N_PANELS = 4;
SYNC = 1;
RATE = 2;
PHASE = 3;
HIST = 4;

%% Create panels from new Panel objects
vectorStrength = CalcVSPH(ds, 'anwin', params.anWin);
panel(SYNC) = syncPanel(ds, vectorStrength);

rate = CalcRATE(ds, 'anwin', params.anWin);
panel(RATE) = ratePanel(ds, rate);

panel(PHASE) = phasePanel(ds, vectorStrength);

% Cycle histograms: need multiple panels
cycleHist = CalcPRDH(ds, 'anwin', params.anWin);
nHistPlots = length(cycleHist.hist);
for cHistPlot = 1:nHistPlots
    panel(HIST + cHistPlot - 1) = chPanel(ds, cycleHist, cHistPlot); 
end

% Calculate rows and columns for the histplots
% Use max 2 rows
nHistPlotY = ((nHistPlots > 3) + 1);
nHistPlotX = max([3, ceil(nHistPlots/2)]); % max width of a histplot is a third of the figure

% How many cells does one of the panels above take?
nPanelPlots = round(nHistPlotX * nHistPlotY);

%% plot everything
for cPanel = [SYNC RATE PHASE]
    startCell = (cPanel-1)*nPanelPlots + 1;
    endCell = cPanel*nPanelPlots;
    subplot(N_PANELS*nHistPlotY, nHistPlotX, startCell:endCell);
    panel(cPanel) = redraw( panel(cPanel) );
end

for cPanel=1:nHistPlots
    subplot(N_PANELS*nHistPlotY, nHistPlotX, 3*nPanelPlots + cPanel);
    panel(cPanel + HIST - 1) = redraw( panel(cPanel + HIST - 1) );
end

%% output struct
T.ds1.filename = ds.filename;
T.ds1.icell = ds.icell;
T.ds1.iseq = ds.iseq;
T.ds1.seqid = ds.seqid;
T.tag = 0;
T.createdby = mfilename;
%Cell parameters halen uit userdata ...
UD = getuserdata_Kold(ds);
if ~isempty(UD) & ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq)
    dsTHR = dataset(T.ds1.filename, UD.CellInfo.THRSeq);
    [T.thr.cf, T.thr.sr, T.thr.thr, T.thr.bw, T.thr.q10] = evalthr(dsTHR);
else
    [T.thr.cf, T.thr.sr, T.thr.thr, T.thr.bw, T.thr.q10] = deal(NaN); 
end
T.BinFreq               = vectorStrength.param.binfreq;
T.R                     = vectorStrength.curve.r;
T.Phase                 = vectorStrength.curve.ph;
T.RaySig                = vectorStrength.curve.raysign;
T.Indepval=vectorStrength.curve.indepval;
T.Raysign=vectorStrength.curve.raysign;

%display(vectorStrength.curve.indepval)
%display(vectorStrength.curve.raysign)
