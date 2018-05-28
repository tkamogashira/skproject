function [RAPStat, LineNr, ErrTxt] = RAPCmdYM(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 04-11-2003

%-------------------------------------RAP Syntax------------------------------------
%   YM #                      Maximum value along Y-axis
%   YM DEF                    Default value for Y-maximum
%-----------------------------------------------------------------------------------

ErrTxt = '';

DefValue = ManageRAPStatus('PlotParam.Axis.Y.Limits');

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current ordinate limits are %s.\n', ConvRAPStatLimits(RAPStat.PlotParam.Axis.Y.Limits)); end
elseif ischar(Token) & strcmp(Token, 'def'), 
    RAPStat.PlotParam.Axis.Y.Limits(2) = DefValue(2);
else, 
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    [YHiLim, ErrTxt] = GetRAPFloat(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    if YHiLim <= RAPStat.PlotParam.Axis.Y.Limits(1), ErrTxt = 'Invalid Range'; return;
    else, RAPStat.PlotParam.Axis.Y.Limits(2) = YHiLim; end
end

LineNr = LineNr + 1;