function [RAPStat, LineNr, ErrTxt] = RAPCmdPHCONV(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 25-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   PHCONV LEAD/LAG           Set phase convention to lead or lag (*)
%   PHCONV DEF                Set phase convention to default (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Phase convention is %s.\n', GetRAPCalcParam(RAPStat, 's', 'PhaseConv')); end
elseif strcmpi(Token, 'def'), 
    RAPStat.CalcParam.PhaseConv = ManageRAPStatus('CalcParam.PhaseConv');
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    RAPStat.CalcParam.PhaseConv = lower(Token);
end

LineNr = LineNr + 1;