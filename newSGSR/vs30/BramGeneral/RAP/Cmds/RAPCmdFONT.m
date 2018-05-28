function [RAPStat, LineNr, ErrTxt] = RAPCmdFONT(RAPStat, LineNr, FirstToken, SecToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 09-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   FONT @@ @@@...@@@ 		  Character Font name of any of : (*)
%                               HDR  : Header
%                               TI   : Plot title
%                               LBL  : Label along all axes
%			                	XLBL : Label along X-axis
%	                			YLBL : Label along Y-axis
%                    			TIC  : Tick labels along all axes
%                               TXT  : Plot text
%                               ALL  : All of the above
%   FONT @@ DEF		          Default font for any of the above
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2), FirstToken = 'disp'; 
elseif ~strcmpi(SecToken, 'def'),
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    [FontName, ErrTxt] = GetRAPChar(RAPStat, SecToken); 
    if ~isempty(ErrTxt), return; 
    elseif ~any(strcmpi(FontName, listfonts)), ErrTxt = 'Invalid fontname for this system'; return; end
end

switch FirstToken
case 'disp',
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
        fprintf('Font names\n');
        fprintf('----------\n');
        fprintf('Header font name         : %s\n', RAPStat.PlotParam.Header.FontName);
        fprintf('Title font name          : %s\n', RAPStat.PlotParam.Axis.Title.FontName);
        fprintf('Abcis label font name    : %s\n', RAPStat.PlotParam.Axis.X.Label.FontName);
        fprintf('Ordinate label font name : %s\n', RAPStat.PlotParam.Axis.Y.Label.FontName);
        fprintf('Ticks font name          : %s\n', RAPStat.PlotParam.Axis.Tic.FontName);
        fprintf('Text font name           : %s\n', RAPStat.PlotParam.Axis.Text.FontName);
    end
case 'xlbl',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.X.Label.FontName = ManageRAPStatus('PlotParam.Axis.X.Label.FontName');
    else, RAPStat.PlotParam.Axis.X.Label.FontName = FontName; end
case 'ylbl',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Y.Label.FontName = ManageRAPStatus('PlotParam.Axis.Y.Label.FontName');
    else, RAPStat.PlotParam.Axis.Y.Label.FontName = FontName;  end
case 'lbl',
    if strcmp(SecToken, 'def'), 
        RAPStat.PlotParam.Axis.X.Label.FontName = ManageRAPStatus('PlotParam.Axis.X.Label.FontName');
        RAPStat.PlotParam.Axis.Y.Label.FontName = ManageRAPStatus('PlotParam.Axis.Y.Label.FontName');
    else, [RAPStat.PlotParam.Axis.X.Label.FontName, RAPStat.PlotParam.Axis.Y.Label.FontName] = deal(FontName); end
case 'tic',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Tic.FontName = ManageRAPStatus('PlotParam.Axis.Tic.FontName');
    else, RAPStat.PlotParam.Axis.Tic.FontName = FontName; end
case 'txt',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Text.FontName = ManageRAPStatus('PlotParam.Axis.Text.FontName');
    else, RAPStat.PlotParam.Axis.Text.FontName = FontName; end
case 'hdr',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Header.FontName = ManageRAPStatus('PlotParam.Header.FontName');
    else, RAPStat.PlotParam.Header.FontName = FontName; end
case 'ti',
    if strcmp(SecToken, 'def'), RAPStat.PlotParam.Axis.Title.FontName = ManageRAPStatus('PlotParam.Axis.Title.FontName');
    else, RAPStat.PlotParam.Axis.Title.FontName = FontName; end
case 'all',
    if strcmp(SecToken, 'def'), 
        RAPStat.PlotParam.Axis.X.Label.FontName = ManageRAPStatus('PlotParam.Axis.X.Label.FontName');
        RAPStat.PlotParam.Axis.Y.Label.FontName = ManageRAPStatus('PlotParam.Axis.Y.Label.FontName');
        RAPStat.PlotParam.Axis.Tic.FontName = ManageRAPStatus('PlotParam.Axis.Tic.FontName');
        RAPStat.PlotParam.Axis.Text.FontName = ManageRAPStatus('PlotParam.Axis.Text.FontName');
        RAPStat.PlotParam.Header.FontName = ManageRAPStatus('PlotParam.Header.FontName');
        RAPStat.PlotParam.Axis.Title.FontName = ManageRAPStatus('PlotParam.Axis.Title.FontName');
    else, 
        [RAPStat.PlotParam.Axis.X.Label.FontName, RAPStat.PlotParam.Axis.Y.Label.FontName, ...
         RAPStat.PlotParam.Axis.Tic.FontName, RAPStat.PlotParam.Axis.Text.FontName, ...
         RAPStat.PlotParam.Header.FontName, RAPStat.PlotParam.Axis.Title.FontName] = deal(FontName); 
    end
end    

LineNr = LineNr + 1;