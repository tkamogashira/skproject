function [RAPStat, LineNr, ErrTxt] = RAPCmdSTYLE(RAPStat, LineNr, LiToken, ObjToken, Style)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-07-2005

%-------------------------------------RAP Syntax------------------------------------
%   STYLE LI @@ @             Line styles of any of the following (*)
%         	                    TH   : Threshold curve
%                               SP   : Rate curve
%                               SC   : Correlograms
%                               VS   : Vector strength curves
%                               SCP  : Scatterplot
%                               ERR  : Error bars
%                               AW   : Analysis window
%                               ALL  : All of the above
%   STYLE LI @@ DEF		     Default line style for rate plot (*)
%-----------------------------------------------------------------------------------

%------------------------------implementation details-------------------------------
%   Line styles have to be supplied between double quotes, otherwise the tokenizer 
%   will interpret the linestyles as expressions.
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 3), ObjToken = 'disp';
elseif ~strcmpi(Style, 'def'),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [Style, ErrTxt] = GetRAPChar(RAPStat, Style); 
    if ~isempty(ErrTxt), return;
    elseif ~any(strcmp(Style, {'-', ':', '--', '-.'})), ErrTxt = 'Invalid line style'; return; end
end
    
switch ObjToken
case 'disp',
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
        fprintf('Line styles\n');
        fprintf('-----------\n');
        fprintf('An. window linestyle   : %s\n', RAPStat.PlotParam.AnWin.LineStyle);
        fprintf('Thr. curve linestyle   : %s\n', RAPStat.PlotParam.Thr.LineStyle);
        fprintf('Rate curve linestyle   : %s\n', RAPStat.PlotParam.Rate.LineStyle);
        fprintf('Error bars linestyle   : %s\n', RAPStat.PlotParam.Rate.ErrorBars.LineStyle);
        fprintf('Correlograms linestyle : %s\n', RAPStat.PlotParam.Corr.LineStyle);
        fprintf('VS curves linestyle    : %s\n', RAPStat.PlotParam.Vs.LineStyle);
        fprintf('Scatterplot linestyle  : %s\n', RAPStat.PlotParam.Scp.LineStyle);
    end
case 'th',
    if ischar(Style) & strcmp(Style, 'def'), RAPStat.PlotParam.Thr.LineStyle = ManageRAPStatus('PlotParam.Thr.LineStyle');
    else, RAPStat.PlotParam.Thr.LineStyle = Style; end
case 'sp',
    if ischar(Style) & strcmp(Style, 'def'), RAPStat.PlotParam.Rate.LineStyle = ManageRAPStatus('PlotParam.Rate.LineStyle');
    else, RAPStat.PlotParam.Rate.LineStyle = Style; end
case 'sc',
    if ischar(Style) & strcmp(Style, 'def'), RAPStat.PlotParam.Corr.LineStyle = ManageRAPStatus('PlotParam.Corr.LineStyle');
    else, RAPStat.PlotParam.Corr.LineStyle = Style; end
case 'vs',
    if ischar(Style) & strcmp(Style, 'def'), RAPStat.PlotParam.Vs.LineStyle = ManageRAPStatus('PlotParam.Vs.LineStyle');
    else, RAPStat.PlotParam.Vs.LineStyle = Style; end
case 'scp',
    if ischar(Style) & strcmp(Style, 'def'), RAPStat.PlotParam.Scp.LineStyle = ManageRAPStatus('PlotParam.Scp.LineStyle');
    else, RAPStat.PlotParam.Scp.LineStyle = Style; end
case 'aw',
    if ischar(Style) & strcmp(Style, 'def'), RAPStat.PlotParam.AnWin.LineStyle = ManageRAPStatus('PlotParam.AnWin.LineStyle');
    else, RAPStat.PlotParam.AnWin.LineStyle = Style; end
case 'err',
    if ischar(Style) & strcmp(Style, 'def'), RAPStat.PlotParam.Rate.ErrorBars.LineStyle = ManageRAPStatus('PlotParam.Rate.ErrorBars.LineStyle');
    else, RAPStat.PlotParam.Rate.ErrorBars.LineStyle = Style; end
case 'all',
    if ischar(Style) & strcmp(Style, 'def'), 
        RAPStat.PlotParam.AnWin.LineStyle  = ManageRAPStatus('PlotParam.AnWin.LineStyle');
        RAPStat.PlotParam.Thr.LineStyle    = ManageRAPStatus('PlotParam.Thr.LineStyle');
        RAPStat.PlotParam.Rate.LineStyle   = ManageRAPStatus('PlotParam.Rate.LineStyle');
        RAPStat.PlotParam.Rate.ErrorBars.LineStyle = ManageRAPStatus('PlotParam.Rate.ErrorBars.LineStyle');
        RAPStat.PlotParam.Corr.LineStyle   = ManageRAPStatus('PlotParam.Corr.LineStyle');
        RAPStat.PlotParam.Vs.LineStyle     = ManageRAPStatus('PlotParam.Vs.LineStyle');
        RAPStat.PlotParam.Scp.LineStyle    = ManageRAPStatus('PlotParam.Scp.LineStyle');        
    else,
        [RAPStat.PlotParam.AnWin.LineStyle, RAPStat.PlotParam.Thr.LineStyle, RAPStat.PlotParam.Rate.LineStyle, ...
                RAPStat.PlotParam.Corr.LineStyle, RAPStat.PlotParam.Vs.LineStyle, ...
                RAPStat.PlotParam.Scp.LineStyle, RAPStat.PlotParam.Rate.ErrorBars.LineStyle] = deal(Style); 
    end
end

LineNr = LineNr + 1;