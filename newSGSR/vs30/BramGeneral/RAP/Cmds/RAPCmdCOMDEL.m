function [RAPStat, LineNr, ErrTxt] = RAPCmdCOMDEL(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 25-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   COMDEL #                      Set compensating delay (*)
%   COMDEL DEF                    Set compensating delay to default (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Compensating delay is %s.\n', GetRAPCalcParam(RAPStat, 's', 'CompDelay')); end
elseif ischar(Token) & strcmpi(Token, 'def'), 
    RAPStat.CalcParam.CompDelay = ManageRAPStatus('CalcParam.CompDelay');
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    [CompDelay, ErrTxt] = GetRAPFloat(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    if (CompDelay >= 0), RAPStat.CalcParam.CompDelay = CompDelay;
    else, ErrTxt = 'The compensating delay cannot be negative'; return; end
end

LineNr = LineNr + 1;