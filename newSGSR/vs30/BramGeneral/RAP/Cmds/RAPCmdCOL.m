function [RAPStat, LineNr, ErrTxt] = RAPCmdCOL(RAPStat, LineNr, FirstToken, SecToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 02-08-2005

%-------------------------------------RAP Syntax------------------------------------
%   COL @@ @		          Color for any of the following : (*)
%                               HDR  : Header
%               				XX   : X-axis
%               				YX   : Y-axis
%               				AX   : All axes
%               				XLBL : Label along X-axis
%               				YLBL : Label along Y-axis
%               				TI   : Title
%               				TXT  : Text
%                               TH   : Line of threshold curve
%                               SP   : Line of rate curve
%               				HI   : Histogram edges
%                               SC   : Line of correlograms
%                               VS   : Line of vector strength curves
%                               SCP  : Scatterplot
%                               AW   : Analysis window
%                               ERR  : Error bars
%                               ALL  : All of the above           
%   COL @@ DEF		          Default Colors for any of the above
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2), FirstToken = 'disp'; 
elseif ~strcmpi(SecToken, 'def'),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [Col, ErrTxt] = GetRAPChar(RAPStat, SecToken); 
    if ~isempty(ErrTxt), return;
    elseif ~any(strcmpi(Col, {'r', 'g', 'b', 'y', 'c', 'm', 'k', 't'})), ErrTxt = 'Invalid color symbol'; return; end
end

switch FirstToken
case 'disp',
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
        fprintf('Color settings\n');
        fprintf('--------------\n');
        fprintf('Header color           : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Header.Color));
        fprintf('Title color            : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Axis.Title.Color));
        fprintf('Abcis color            : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Axis.X.Color));
        fprintf('Abcis label color      : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Axis.X.Label.Color));
        fprintf('Ordinate color         : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Axis.Y.Color));
        fprintf('Ordinate label color   : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Axis.Y.Label.Color));
        fprintf('Text color             : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Axis.Text.Color));
        fprintf('An. window patch color : %s\n', ConvRAPStatColor(RAPStat.PlotParam.AnWin.FaceColor));
        fprintf('Thr. curve linecolor   : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Thr.LineColor));
        fprintf('Rate curve linecolor   : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Rate.LineColor));
        fprintf('Error bars linecolor   : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Rate.ErrorBars.LineColor));
        fprintf('Histograms edgecolor   : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Hist.EdgeColor));
        fprintf('Correlograms linecolor : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Corr.LineColor));
        fprintf('VS curves linecolor    : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Vs.LineColor));
        fprintf('Scatterplot linecolor  : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Scp.LineColor));
    end
case 'hdr',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Header.Color = ManageRAPStatus('PlotParam.Header.Color');
    else, RAPStat.PlotParam.Header.Color = ColSym2RGB(Col); end
case 'xx',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.X.Color = ManageRAPStatus('PlotParam.Axis.X.Color');
    else, RAPStat.PlotParam.Axis.X.Color = ColSym2RGB(Col); end
case 'yx',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Y.Color = ManageRAPStatus('PlotParam.Axis.Y.Color');
    else, RAPStat.PlotParam.Axis.Y.Color = ColSym2RGB(Col); end
case 'ax'
    if strcmp(SecToken, 'def'), 
        RAPStat.PlotParam.Axis.X.Color = ManageRAPStatus('PlotParam.Axis.X.Color');
        RAPStat.PlotParam.Axis.Y.Color = ManageRAPStatus('PlotParam.Axis.Y.Color');
    else, [RAPStat.PlotParam.Axis.X.Color, RAPStat.PlotParam.Axis.Y.Color] = deal(ColSym2RGB(Col)); end
case 'xlbl',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.X.Label.Color = ManageRAPStatus('PlotParam.Axis.X.Label.Color');
    else, RAPStat.PlotParam.Axis.X.Label.Color = ColSym2RGB(Col); end
case 'ylbl',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Y.Label.Color = ManageRAPStatus('PlotParam.Axis.Y.Label.Color');
    else, RAPStat.PlotParam.Axis.Y.Label.Color = ColSym2RGB(Col); end
case 'ti',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Title.Color = ManageRAPStatus('PlotParam.Axis.Title.Color');
    else, RAPStat.PlotParam.Axis.Title.Color = ColSym2RGB(Col); end
case 'txt',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Text.Color = ManageRAPStatus('PlotParam.Axis.Text.Color');
    else, RAPStat.PlotParam.Axis.Text.Color = ColSym2RGB(Col); end
case 'th',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Thr.LineColor = ManageRAPStatus('PlotParam.Thr.LineColor');
    else, RAPStat.PlotParam.Thr.LineColor = ColSym2RGB(Col); end
case 'sp',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Rate.LineColor = ManageRAPStatus('PlotParam.Rate.LineColor');
    else, RAPStat.PlotParam.Rate.LineColor = ColSym2RGB(Col); end
case 'hi',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Hist.EdgeColor = ManageRAPStatus('PlotParam.Hist.EdgeColor');
    else, RAPStat.PlotParam.Hist.EdgeColor = ColSym2RGB(Col); end
case 'sc',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Corr.LineColor = ManageRAPStatus('PlotParam.Corr.LineColor');
    else, RAPStat.PlotParam.Corr.LineColor = ColSym2RGB(Col); end
case 'vs',    
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Vs.LineColor = ManageRAPStatus('PlotParam.Vs.LineColor');
    else, RAPStat.PlotParam.Vs.LineColor = ColSym2RGB(Col); end
case 'scp',    
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Scp.LineColor = ManageRAPStatus('PlotParam.Scp.LineColor');
    else, RAPStat.PlotParam.Scp.LineColor = ColSym2RGB(Col); end
case 'aw',    
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.AnWin.FaceColor = ManageRAPStatus('PlotParam.AnWin.FaceColor');
    else, RAPStat.PlotParam.AnWin.FaceColor = ColSym2RGB(Col); end
case 'err',    
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Rate.ErrorBars.LineColor = ManageRAPStatus('PlotParam.Rate.ErrorBars.LineColor');
    else, RAPStat.PlotParam.Rate.ErrorBars.LineColor = ColSym2RGB(Col); end
case 'all',
    if strcmp(SecToken, 'def'), 
        RAPStat.PlotParam.Header.Color = ManageRAPStatus('PlotParam.Header.Color');
        RAPStat.PlotParam.Axis.X.Color = ManageRAPStatus('PlotParam.Axis.X.Color');
        RAPStat.PlotParam.Axis.Y.Color = ManageRAPStatus('PlotParam.Axis.Y.Color');
        RAPStat.PlotParam.Axis.X.Label.Color = ManageRAPStatus('PlotParam.Axis.X.Label.Color');
        RAPStat.PlotParam.Axis.Y.Label.Color = ManageRAPStatus('PlotParam.Axis.Y.Label.Color');
        RAPStat.PlotParam.Axis.Text.Color = ManageRAPStatus('PlotParam.Axis.Text.Color');
        RAPStat.PlotParam.Axis.Title.Color = ManageRAPStatus('PlotParam.Axis.Title.Color');
        RAPStat.PlotParam.AnWin.FaceColor = ManageRAPStatus('PlotParam.AnWin.FaceColor');
        RAPStat.PlotParam.Thr.LineColor = ManageRAPStatus('PlotParam.Rate.LineColor');
        RAPStat.PlotParam.Rate.LineColor = ManageRAPStatus('PlotParam.Rate.LineColor');
        RAPStat.PlotParam.Rate.ErrorBars.LineColor = ManageRAPStatus('PlotParam.Rate.ErrorBars.LineColor');
        RAPStat.PlotParam.Hist.FaceColor = ManageRAPStatus('PlotParam.Hist.FaceColor');
        RAPStat.PlotParam.Hist.EdgeColor = ManageRAPStatus('PlotParam.Hist.EdgeColor');
        RAPStat.PlotParam.Corr.LineColor = ManageRAPStatus('PlotParam.Rate.LineColor');
        RAPStat.PlotParam.Vs.LineColor = ManageRAPStatus('PlotParam.Rate.LineColor');
        RAPStat.PlotParam.Scp.LineColor = ManageRAPStatus('PlotParam.Scp.LineColor');
    else,
        [RAPStat.PlotParam.Header.Color, RAPStat.PlotParam.Axis.X.Color, ...
                RAPStat.PlotParam.Axis.Y.Color, RAPStat.PlotParam.Axis.X.Label.Color, ...
                RAPStat.PlotParam.Axis.Y.Label.Color, RAPStat.PlotParam.Axis.Text.Color, ...
                RAPStat.PlotParam.Axis.Title.Color, RAPStat.PlotParam.Thr.LineColor, ...
                RAPStat.PlotParam.Rate.LineColor, RAPStat.PlotParam.Hist.FaceColor, ...
                RAPStat.PlotParam.Hist.EdgeColor, RAPStat.PlotParam.Corr.LineColor, ...
                RAPStat.PlotParam.Vs.LineColor, RAPStat.PlotParam.AnWin.FaceColor, ...
                RAPStat.PlotParam.Scp.LineColor, RAPStat.PlotParam.Rate.ErrorBars.LineColor] = ...
            deal(ColSym2RGB(Col)); 
    end
end

LineNr = LineNr + 1;