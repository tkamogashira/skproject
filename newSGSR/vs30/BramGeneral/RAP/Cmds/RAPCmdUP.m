function [RAPStat, LineNr, ErrTxt] = RAPCmdMORE(RAPStat, LineNr, ToggleToken)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-07-2005

%-------------------------------------RAP Syntax------------------------------------
%   UP YES/NO/DEF             Unwrap phase (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
       fprintf('Phase unwrapping is set to : %s\n', GetRAPCalcParam(RAPStat, 's', 'UnWrapping'));
    end
elseif strcmpi(ToggleToken, 'def'), RAPStat.CalcParam.UnWrapping = ManageRAPStatus('CalcParam.UnWrapping');
else, RAPStat.CalcParam.UnWrapping = lower(ToggleToken); end

LineNr = LineNr + 1;