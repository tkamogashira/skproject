function [RAPStat, LineNr, ErrTxt] = RAPCmdMIN(RAPStat, LineNr, ISToken, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   MIN IS #                  Minimum Interspike Interval allowed (millsecs)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 3),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current minimum ISI is %s.\n', GetRAPCalcParam(RAPStat, 's', 'MinISI')); end
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    [MinISI, ErrTxt] = GetRAPFloat(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    
    if (MinISI < 0), ErrTxt = 'Minimum interspike interval cannot be negative'; return; end
    RAPStat.CalcParam.MinISI = MinISI;
end

LineNr = LineNr + 1;