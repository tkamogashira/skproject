function [RAPStat, LineNr, ErrTxt] = RAPCmdNL(RAPStat, LineNr, PlotType, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 24-06-2004

%-------------------------------------RAP Syntax------------------------------------
%   NL TH			          Calculate Threshold (Tuning) curve plot and discard output
%   NL SP [COUNT/RATE]        Calculate spike counts or rates vs. variable and discard output
%   NL RAS                    Calculate dot raster and discard output
%   NL SYNC/SY	              Calculate Sync. Coeff. vs variable and discard output
%   NL PHASE/PH		          Calculate Phase vs. variables and discard output
%   NL PST/PS                 Calculate Post Stimulus Time Histograms and discard output
%   NL ISI			          Calculate Inter-spike interval Histograms and discard output
%   NL CH			          Calculate Cycle (or Phase) Histograms and discard output
%   NL LAT 		       	      Calculate First Spiketime Latency Histograms and discard output
%   NL SAC [COUNT/RATE/NORM]  Calculate Shuffled AutoCorrelation and discard output
%   NL XC [COUNT/RATE/NORM]   Calculate CrossCorrelation and discard output
%   NL DIF [COUNT/RATE/NORM]  Calculate DifCor and discard output 
%   NL RGL [CV]		          Calculate regularity analysis (CV vs time)
%   NL RGL MEAN		          Calculate regularity analysis (Mean & St.dev)
%   NL PKL                    Calculate Peak latency (*)
%   NL SCP @@..@@ @@..@@      Assemble scatterplot and discard output
%   NL TRD [COUNT/RATE]       Calculate Trial Rate Distribution and discard output 
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 4), OptArg = varargin{1};
elseif (nargin == 5), [XExpr, YExpr] = deal(varargin{:}); end

switch PlotType
case 'th',     %Threshold curve ...
    [RAPStat, dummy, ErrTxt] = CalcRAPThr(RAPStat);
case 'sp',     %Rate curve ...
    if exist('OptArg', 'var'), RAPStat.PlotParam.Rate.YAxisUnit = OptArg; end
    [RAPStat, dummy, ErrTxt] = CalcRAPRate(RAPStat);
    RAPStat.PlotParam.Rate.YAxisUnit = ManageRAPStatus('PlotParam.Rate.YAxisUnit');
case 'ras',    %Dot raster ...
    %No data extracted from a Raster Plot, so nothing is done ...                     
case {'sync', 'sy'},   %Vector Strength Magnitude versus Independent Variable curve ...
    [RAPStat, dummy, ErrTxt] = CalcRAPVsm(RAPStat);
case {'phase', 'ph'}   %Vector Strength Phase versus Independent Variable curve ... 
    [RAPStat, dummy, ErrTxt] = CalcRAPVsp(RAPStat);
case {'pst', 'ps'},    %Post-Stimulus Time histogram ...
    [RAPStat, dummy, ErrTxt] = CalcRAPPsth(RAPStat);
case 'ch',     %Period histogram ...
    [RAPStat, dummy, ErrTxt] = CalcRAPPrdh(RAPStat);
case 'isi',    %InterSpike Interval histogram ...
    [RAPStat, dummy, ErrTxt] = CalcRAPIsih(RAPStat);
case 'lat',    %First Spike Latency histogram ...
    [RAPStat, dummy, ErrTxt] = CalcRAPFslh(RAPStat);
case 'sac',    %Shuffled AutoCorrelogram ...
    if exist('OptArg', 'var'), RAPStat.PlotParam.Corr.YAxisUnit = OptArg; end
    [RAPStat, dummy, ErrTxt] = CalcRAPSac(RAPStat);
    RAPStat.PlotParam.Corr.YAxisUnit = ManageRAPStatus('PlotParam.Corr.YAxisUnit');
case 'xc',     %CrossCorrelogram ...
    if exist('OptArg', 'var'), RAPStat.PlotParam.Corr.YAxisUnit = OptArg; end
    [RAPStat, dummy, ErrTxt] = CalcRAPXc(RAPStat);
    RAPStat.PlotParam.Corr.YAxisUnit = ManageRAPStatus('PlotParam.Corr.YAxisUnit');
case 'dif',    %DifCor ...
    if exist('OptArg', 'var'), RAPStat.PlotParam.Corr.YAxisUnit = OptArg; end
    [RAPStat, dummy, ErrTxt] = CalcRAPDif(RAPStat);
    RAPStat.PlotParam.Corr.YAxisUnit = ManageRAPStatus('PlotParam.Corr.YAxisUnit');
case 'rgl',    %Regularity analysis ...
    if exist('OptArg', 'var'), RAPStat.PlotParam.Rgl.YAxisUnit = OptArg; end
    [RAPStat, dummy, ErrTxt] = CalcRAPRglh(RAPStat);
    RAPStat.PlotParam.Rgl.YAxisUnit = ManageRAPStatus('PlotParam.Rgl.YAxisUnit');
case 'pkl',    %Peak latency plot ...
    [RAPStat, dummy, ErrTxt] = CalcRAPPkl(RAPStat);
case 'scp',    %Scatterplot ...
    [RAPStat, dummy, ErrTxt] = AssembleRAPScatterPlot(RAPStat, XExpr, YExpr);
case 'trd',    %Trial rate distribution ...
    if exist('OptArg', 'var'), RAPStat.PlotParam.Trd.YAxisUnit = OptArg; end
    [RAPStat, dummy, ErrTxt] = CalcRAPTrd(RAPStat);
    RAPStat.PlotParam.Trd.YAxisUnit = ManageRAPStatus('PlotParam.Trd.YAxisUnit');
end

if isempty(ErrTxt), LineNr = LineNr + 1; end