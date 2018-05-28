function [RAPStat, LineNr, ErrTxt] = RAPCmdXM(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   XM #                      Maximum value along X-axis
%   XM DEF                    Default value for X-maximum
%-----------------------------------------------------------------------------------

ErrTxt = '';

DefValue = ManageRAPStatus('PlotParam.Axis.X.Limits');

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current abcis limits are %s.\n', ConvRAPStatLimits(RAPStat.PlotParam.Axis.X.Limits)); end
elseif ischar(Token) & strcmp(Token, 'def'), 
    RAPStat.PlotParam.Axis.X.Limits(2) = DefValue(2);
else, 
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end

    [XHiLim, ErrTxt] = GetRAPFloat(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    if XHiLim <= RAPStat.PlotParam.Axis.X.Limits(1), ErrTxt = 'Invalid Range'; return;
    else, RAPStat.PlotParam.Axis.X.Limits(2) = XHiLim; end
end

LineNr = LineNr + 1;