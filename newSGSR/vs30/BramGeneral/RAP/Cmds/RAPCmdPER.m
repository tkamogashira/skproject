function [RAPStat, LineNr, ErrTxt] = RAPCmdPER(RAPStat, LineNr, Token1, Token2)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 24-06-2004

%-------------------------------------RAP Syntax------------------------------------
%   PER PKL #		          Percent for peak latency computation
%   PER PKL DEF		          Default percent for peak latency
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 3),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
        fprintf('Rate increase for peak latency computation is %s.\n', GetRAPCalcParam(RAPStat, 's', 'PklRateInc')); 
    end
elseif ischar(Token2) & strcmpi(Token2, 'def'), RAPStat.CalcParam.PklRateInc = ManageRAPStatus('CalcParam.PklRateInc');
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    [RateInc, ErrTxt] = GetRAPFloat(RAPStat, Token2);
    if ~isempty(ErrTxt), return; end
    if (RateInc >= 0) & (RateInc <= 100), RAPStat.CalcParam.PklRateInc = RateInc;
    else, ErrTxt = 'The rate increase must be between 0 and 100%'; return; end
end    

LineNr = LineNr + 1;