function [RAPStat, LineNr, ErrTxt] = RAPCmdSUB(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 25-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   SUB #                     Subtract constant from each spike time before analysis
%                             (in millisecs)(default=0)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current subtraction constant is %s.\n', GetRAPCalcParam(RAPStat, 's', 'ConSubTr')); end
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    [TimeConst, ErrTxt] = GetRAPFloat(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    
    if (TimeConst < 0), ErrTxt = 'Time constant cannot be negative'; return; end
    RAPStat.CalcParam.ConSubTr = TimeConst;
end
    
LineNr = LineNr + 1;