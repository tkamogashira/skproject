function [RAPStat, LineNr, ErrTxt] = RAPCmdSZ(RAPStat, LineNr, FirstToken, SecToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 09-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   SZ @@ # 		          Font size of any of : (*)
%                               HDR  : Header
%                               TI   : Plot title
%                               LBL  : Label along all axes
%			                	XLBL : Label along X-axis
%	                			YLBL : Label along Y-axis
%                    			TIC  : Tick labels along all axes
%                               TXT  : Plot text
%                               ALL  : All of the above
%   SZ @@ DEF		          Default font for any of the above (*)
%-----------------------------------------------------------------------------------

%----------------------------implementation details---------------------------------
%   All fontsizes are given in percentage of the height of the accommodating object.
%   For the fontsize of the header, this is the height of the header. For the other
%   fontsizes, this is the height of axis object.
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2), FirstToken = 'disp'; 
elseif ~strcmpi(SecToken, 'def'),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [Sz, ErrTxt] = GetRAPFloat(RAPStat, SecToken); 
    if ~isempty(ErrTxt), return; 
    elseif (Sz <= 0) | (Sz > 1), ErrTxt = 'Invalid fontsize'; return; end
end

switch FirstToken
case 'disp',
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
        fprintf('Font sizes\n');
        fprintf('----------\n');
        fprintf('Header font size         : %.2f%%(header height)\n', RAPStat.PlotParam.Header.FontSize);
        fprintf('Title font size          : %.2f%%(plot height)\n', RAPStat.PlotParam.Axis.Title.FontSize);
        fprintf('Abcis label font size    : %.2f%%(plot height)\n', RAPStat.PlotParam.Axis.X.Label.FontSize);
        fprintf('Ordinate label font size : %.2f%%(plot height)\n', RAPStat.PlotParam.Axis.Y.Label.FontSize);
        fprintf('Ticks font size          : %.2f%%(plot height)\n', RAPStat.PlotParam.Axis.Tic.FontSize);
        fprintf('Text font size           : %.2f%%(plot height)\n', RAPStat.PlotParam.Axis.Text.FontSize);
    end
case 'xlbl',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.X.Label.FontSize = ManageRAPStatus('PlotParam.Axis.X.Label.FontSize');
    else, RAPStat.PlotParam.Axis.X.Label.FontSize = Sz; end
case 'ylbl',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Y.Label.FontSize = ManageRAPStatus('PlotParam.Axis.Y.Label.FontSize');
    else, RAPStat.PlotParam.Axis.Y.Label.FontSize = Sz; end
case 'lbl',
    if strcmp(SecToken, 'def'), 
        RAPStat.PlotParam.Axis.X.Label.FontSize = ManageRAPStatus('PlotParam.Axis.X.Label.FontSize');
        RAPStat.PlotParam.Axis.Y.Label.FontSize = ManageRAPStatus('PlotParam.Axis.Y.Label.FontSize');
    else, [RAPStat.PlotParam.Axis.X.Label.FontSize, RAPStat.PlotParam.Axis.Y.Label.FontSize] = deal(Sz); end
case 'tic',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Tic.FontSize = ManageRAPStatus('PlotParam.Axis.Tic.FontSize');
    else, RAPStat.PlotParam.Axis.Tic.FontSize = Sz; end
case 'txt',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Text.FontSize = ManageRAPStatus('PlotParam.Axis.Text.FontSize');
    else, RAPStat.PlotParam.Axis.Text.FontSize = Sz; end
case 'hdr',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Header.FontSize = ManageRAPStatus('PlotParam.Header.FontSize');
    else, RAPStat.PlotParam.Header.FontSize = Sz; end
case 'ti',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Title.FontSize = ManageRAPStatus('PlotParam.Axis.Title.FontSize');
    else, RAPStat.PlotParam.Axis.Title.FontSize = Sz; end
case 'all',
    if strcmp(SecToken, 'def'), 
        RAPStat.PlotParam.Axis.X.Label.FontSize = ManageRAPStatus('PlotParam.Axis.X.Label.FontSize');
        RAPStat.PlotParam.Axis.Y.Label.FontSize = ManageRAPStatus('PlotParam.Axis.Y.Label.FontSize');
        RAPStat.PlotParam.Axis.Tic.FontSize = ManageRAPStatus('PlotParam.Axis.Tic.FontSize');
        RAPStat.PlotParam.Axis.Text.FontSize = ManageRAPStatus('PlotParam.Axis.Text.FontSize');
        RAPStat.PlotParam.Header.FontSize = ManageRAPStatus('PlotParam.Header.FontSize');
        RAPStat.PlotParam.Axis.Title.FontSize = ManageRAPStatus('PlotParam.Axis.Title.FontSize');
    else,
        [RAPStat.PlotParam.Axis.X.Label.FontSize, RAPStat.PlotParam.Axis.Y.Label.FontSize, ...
         RAPStat.PlotParam.Axis.Tic.FontSize, RAPStat.PlotParam.Axis.Text.FontSize, ...
         RAPStat.PlotParam.Header.FontSize, RAPStat.PlotParam.Axis.Title.FontSize] = deal(Sz); 
    end
end    


LineNr = LineNr + 1;