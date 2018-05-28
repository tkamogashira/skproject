function [RAPStat, LineNr, ErrTxt] = RAPCmdRY(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 25-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   RY #                      Rayleigh criterion for cyclehistograms and phase curves
%   RY DEF                    Rayleigh criterion to default
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current rayleigh criterion is %s.\n', GetRAPCalcParam(RAPStat, 's', 'RayCrit')); end
elseif ischar(Token) & strcmpi(Token, 'def'), 
    RAPStat.CalcParam.RayCrit = ManageRAPStatus('CalcParam.RayCrit');
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    [RayCrit, ErrTxt] = GetRAPFloat(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    if (RayCrit >= 0), RAPStat.CalcParam.RayCrit = RayCrit;
    else, ErrTxt = 'The rayleigh criterion cannot be negative'; return; end
end

LineNr = LineNr + 1;