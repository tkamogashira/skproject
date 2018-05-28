function [RAPStat, LineNr, ErrTxt] = RAPCmdBW(RAPStat, LineNr, Token)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 22-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   BW #                      Binwidth in ms for histogram or correlograms
%-----------------------------------------------------------------------------------

%-------------------------------implementation details------------------------------
%   By setting the binwidth, the number of bins calculation parameters is not used.
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current binwidth is %s.\n', GetRAPCalcParam(RAPStat, 's', 'BinWidth')); end
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end

    [BinWidth, ErrTxt] = GetRAPFloat(RAPStat, Token);
    if ~isempty(ErrTxt), return; end
    if (BinWidth > 0), 
        RAPStat.CalcParam.BinWidth = BinWidth;
        RAPStat.CalcParam.NBin     = NaN;
    else, ErrTxt = 'The binwidth used for histograms cannot be negative or zero'; return; end
end

LineNr = LineNr + 1;