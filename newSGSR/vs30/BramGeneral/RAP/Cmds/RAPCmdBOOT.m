function [RAPStat, LineNr, ErrTxt] = RAPCmdBOOT(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 18-10-2003

%-------------------------------------RAP Syntax------------------------------------
%   BOOT #                    Bootstrap for coincidence rate plot (*)
%   BOOT DEF                  Default bootstrap for coincidence rate plot (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current bootstrap is %s.\n', GetRAPCalcParam(RAPStat, 's', 'BootStrap')); end
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    if strcmpi(Token, 'def'),
       RAPStat.CalcParam.BootStrap = ManageRAPStatus('CalcParam.BootStrap');
    else,
       [Bootstrap, ErrTxt] = GetRAPInt(RAPStat, Token);
       if ~isempty(ErrTxt), return; end
       if (Bootstrap >= 0), RAPStat.CalcParam.BootStrap = Bootstrap;
       else, ErrTxt = 'The bootstrap must be a positive integer.'; return; end
    end
end

LineNr = LineNr + 1;