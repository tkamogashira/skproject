function [RAPStat, LineNr, ErrTxt] = RAPCmdNB(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-12-2004

%-------------------------------------RAP Syntax------------------------------------
%   NB #                      No. of bins in histogram or in correlogram
%   NB DEF                    No. of histogram or correlogram bins to default
%-----------------------------------------------------------------------------------

%-------------------------------implementation details------------------------------
%   By setting the number of bins, the binwidth calculation parameters is not used.
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current number of bins is %s.\n', GetRAPCalcParam(RAPStat, 's', 'NBin')); end
elseif ischar(Token) & strcmpi(Token, 'def'), 
    RAPStat.CalcParam.NBin     = ManageRAPStatus('CalcParam.NBin');
    RAPStat.CalcParam.BinWidth = ManageRAPStatus('CalcParam.BinWidth');
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    
    [NBin, ErrTxt] = GetRAPInt(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    if (NBin > 0), 
        RAPStat.CalcParam.NBin     = NBin;
        RAPStat.CalcParam.BinWidth = ManageRAPStatus('CalcParam.BinWidth');
    else, ErrTxt = 'The number of bins used for histograms cannot be negative or zero'; return; end
end

LineNr = LineNr + 1;