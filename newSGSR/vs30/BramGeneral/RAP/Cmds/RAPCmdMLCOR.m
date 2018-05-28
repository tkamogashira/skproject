function [RAPStat, LineNr, ErrTxt] = RAPCmdMLCOR(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 11-05-2004

%-------------------------------------RAP Syntax------------------------------------
%   MLCOR #                      Maximum lag for autocorrelograms
%   MLCOR DEF                    Maximum lag to default
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current maxlag is %s.\n', GetRAPCalcParam(RAPStat, 's', 'CorMaxLag')); end
elseif ischar(Token) & strcmpi(Token, 'def'), 
    RAPStat.CalcParam.CorMaxLag = ManageRAPStatus('CalcParam.CorMaxLag');
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    [MaxLag, ErrTxt] = GetRAPFloat(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    if (MaxLag > 0), RAPStat.CalcParam.CorMaxLag = MaxLag;
    else, ErrTxt = 'The maximum lag for correlograms cannot be negative or zero'; return; end
end

LineNr = LineNr + 1;