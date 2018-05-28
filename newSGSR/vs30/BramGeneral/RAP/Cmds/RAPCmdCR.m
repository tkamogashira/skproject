function [RAPStat, LineNr, ErrTxt] = RAPCmdCR(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 18-10-2003

%-------------------------------------RAP Syntax------------------------------------
%   CR #                      Significance level for coincidence rate plot (*)
%   CR DEF                    Default significance level for coincidence rate plot (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current sign. level is %s.\n', GetRAPCalcParam(RAPStat, 's', 'SignLevel')); end
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    if strcmpi(Token, 'def'),
       RAPStat.CalcParam.SignLevel = ManageRAPStatus('CalcParam.SignLevel');
    else,
       [SignLevel, ErrTxt] = GetRAPFloat(RAPStat, Token);
       if ~isempty(ErrTxt), return; end
       if ((SignLevel >= 0) & (SignLevel <= 1)), RAPStat.CalcParam.SignLevel = SignLevel;
       else, ErrTxt = 'The sign. level must be a real number between zero and one.'; return; end
    end
end

LineNr = LineNr + 1;