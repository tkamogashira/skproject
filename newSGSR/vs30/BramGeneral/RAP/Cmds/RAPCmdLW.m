function [RAPStat, LineNr, ErrTxt] = RAPCmdLW(RAPStat, LineNr, FirstToken, SecToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-07-2005

%-------------------------------------RAP Syntax------------------------------------
%   LW @@ #		              Line weights of any of the following (*)
%	                			AX   : All axes
%         	                    TH   : Threshold curve
%                               SP   : Rate curve
%                               RAS  : Raster plot
%                               SC   : Correlograms
%                               VS   : Vector strength curves
%                               SCP  : Scatterplot
%                               AW   : Analysis window
%                               ERR  : Error bars
%                               ALL  : All of the above
%   LW @@ DEF		          Default line wts for any of the above
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2), FirstToken = 'disp'; 
elseif ~strcmpi(SecToken, 'def'),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [Width, ErrTxt] = GetRAPFloat(RAPStat, SecToken); 
    if ~isempty(ErrTxt), return; 
    elseif Width <= 0, ErrTxt = 'Invalid line width'; return; end
end

switch FirstToken
case 'disp',
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
        fprintf('Line widths (points)\n');
        fprintf('--------------------\n');
        fprintf('Axis linewidth         : %.1f\n', RAPStat.PlotParam.Axis.LineWidth);
        fprintf('An. window linewidth   : %.1f\n', RAPStat.PlotParam.AnWin.LineWidth);
        fprintf('Thr. curve linewidth   : %.1f\n', RAPStat.PlotParam.Thr.LineWidth);
        fprintf('Rate curve linewidth   : %.1f\n', RAPStat.PlotParam.Rate.LineWidth);
        fprintf('Error bars linewidth   : %.1f\n', RAPStat.PlotParam.Rate.ErrorBars.LineWidth);
        fprintf('Raster plot linewidth  : %.1f\n', RAPStat.PlotParam.Raster.LineWidth);
        fprintf('Correlograms linewidth : %.1f\n', RAPStat.PlotParam.Corr.LineWidth);
        fprintf('VS curves linewidth    : %.1f\n', RAPStat.PlotParam.Vs.LineWidth);
        fprintf('Scatterplot linewidth  : %.1f\n', RAPStat.PlotParam.Scp.LineWidth);
    end
case 'ax',
    if ischar(SecToken) & strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.LineWidth = ManageRAPStatus('PlotParam.Axis.LineWidth');
    else, RAPStat.PlotParam.Axis.LineWidth = Width; end
case 'th',
    if ischar(SecToken) & strcmp(SecToken, 'def'), RAPStat.PlotParam.Thr.LineWidth = ManageRAPStatus('PlotParam.Thr.LineWidth');
    else, RAPStat.PlotParam.Thr.LineWidth = Width; end
case 'sp',
    if ischar(SecToken) & strcmp(SecToken, 'def'), RAPStat.PlotParam.Rate.LineWidth = ManageRAPStatus('PlotParam.Rate.LineWidth');
    else, RAPStat.PlotParam.Rate.LineWidth = Width; end
case 'ras',
    if ischar(SecToken) & strcmp(SecToken, 'def'), RAPStat.PlotParam.Raster.LineWidth = ManageRAPStatus('PlotParam.Raster.LineWidth');
    else, RAPStat.PlotParam.Raster.LineWidth = Width; end
case 'sc',
    if ischar(SecToken) & strcmp(SecToken, 'def'), RAPStat.PlotParam.Corr.LineWidth = ManageRAPStatus('PlotParam.Corr.LineWidth');
    else, RAPStat.PlotParam.Corr.LineWidth = Width; end
case 'vs',
    if ischar(SecToken) & strcmp(SecToken, 'def'), RAPStat.PlotParam.Vs.LineWidth = ManageRAPStatus('PlotParam.Vs.LineWidth');
    else, RAPStat.PlotParam.Vs.LineWidth = Width; end
case 'scp',
    if ischar(SecToken) & strcmp(SecToken, 'def'), RAPStat.PlotParam.Scp.LineWidth = ManageRAPStatus('PlotParam.Scp.LineWidth');
    else, RAPStat.PlotParam.Scp.LineWidth = Width; end
case 'aw',
    if ischar(SecToken) & strcmp(SecToken, 'def'), RAPStat.PlotParam.AnWin.LineWidth = ManageRAPStatus('PlotParam.AnWin.LineWidth');
    else, RAPStat.PlotParam.AnWin.LineWidth = Width; end
case 'err',
    if ischar(SecToken) & strcmp(SecToken, 'def'), RAPStat.PlotParam.Rate.ErrorBars.LineWidth = ManageRAPStatus('PlotParam.Rate.ErrorBars.LineWidth');
    else, RAPStat.PlotParam.Rate.ErrorBars.LineWidth = Width; end
case 'all',
    if ischar(SecToken) & strcmp(SecToken, 'def'), 
        RAPStat.PlotParam.Axis.LineWidth   = ManageRAPStatus('PlotParam.Axis.LineWidth');
        RAPStat.PlotParam.AnWin.LineWidth  = ManageRAPStatus('PlotParam.AnWin.LineWidth');
        RAPStat.PlotParam.Thr.LineWidth    = ManageRAPStatus('PlotParam.Thr.LineWidth');
        RAPStat.PlotParam.Rate.LineWidth   = ManageRAPStatus('PlotParam.Rate.LineWidth');
        RAPStat.PlotParam.Rate.ErrorBars.LineWidth = ManageRAPStatus('PlotParam.Rate.ErrorBars.LineWidth');
        RAPStat.PlotParam.Raster.LineWidth = ManageRAPStatus('PlotParam.Raster.LineWidth');
        RAPStat.PlotParam.Corr.LineWidth   = ManageRAPStatus('PlotParam.Corr.LineWidth');
        RAPStat.PlotParam.Vs.LineWidth     = ManageRAPStatus('PlotParam.Vs.LineWidth');
        RAPStat.PlotParam.Scp.LineWidth    = ManageRAPStatus('PlotParam.Scp.LineWidth');
    else, 
        [RAPStat.PlotParam.Axis.LineWidth, RAPStat.PlotParam.Thr.LineWidth, RAPStat.PlotParam.AnWin.LineWidth, ...
                RAPStat.PlotParam.Rate.LineWidth, RAPStat.PlotParam.Raster.LineWidth, ...
                RAPStat.PlotParam.Corr.LineWidth, RAPStat.PlotParam.Vs.LineWidth, ...
                RAPStat.PlotParam.Scp.LineWidth, RAPStat.PlotParam.Rate.ErrorBars.LineWidth] = deal(Width); 
    end
end

LineNr = LineNr + 1;