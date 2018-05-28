function [RAPStat, LineNr, ErrTxt] = RAPCmdCYCLINT(RAPStat, LineNr, ToggleToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 25-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   CYCLINT YES/NO            Integer number of cycles for analysis window on or off (*)
%   CYCLINT DEF               Integer number of cycles for analysis window to default (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Integer number of cycles for an. window is %s.\n', GetRAPCalcParam(RAPStat, 's', 'IntNCycles')); end
elseif strcmpi(ToggleToken, 'def'), 
    RAPStat.CalcParam.IntNCycles = ManageRAPStatus('CalcParam.IntNCycles');
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    RAPStat.CalcParam.IntNCycles = lower(ToggleToken);
end

LineNr = LineNr + 1;