function [RAPStat, LineNr, ErrTxt] = RAPCmdBWCOR(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 07-03-2005

%-------------------------------------RAP Syntax------------------------------------
%   BWCOR #                   Binwidth in ms for autocorrelograms
%   BWCOR DEF                 Binwidth in ms to default
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current correlogram binwidth is %s.\n', GetRAPCalcParam(RAPStat, 's', 'CorBinWidth')); end
elseif ischar(Token) & strcmpi(Token, 'def'), 
    RAPStat.CalcParam.CorBinWidth = ManageRAPStatus('CalcParam.CorBinWidth');
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end

    [BinWidth, ErrTxt] = GetRAPFloat(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    if (BinWidth > 0), RAPStat.CalcParam.CorBinWidth = BinWidth;
    else, ErrTxt = 'The binwidth for correlograms cannot be negative or zero'; return; end
end

LineNr = LineNr + 1;