function Dur = GetRAPWinDur(RAPStat)
%GetRAPWinDur    returns the total duration of the analysis window
%   Dur = GetRAPWinDur(RAPStat) returns the total duration of the analysis
%   window in ms. The duration is the sum of all analysis window ranges minus
%   all the reject window ranges.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 30-10-2003

Dur = [];

if isRAPStatDef(RAPStat, 'GenParam.DS'), return; 
else, ds = RAPStat.GenParam.DS; end

if ~isRAPStatDef(RAPStat, 'CalcParam.AnWin'), 
    Dur = CalcWinDur(RAPStat.CalcParam.AnWin);
else, Dur = ds.burstdur(1); end

if ~isRAPStatDef(RAPStat, 'CalcParam.ReWin'), 
    Dur = Dur - CalcWinDur(RAPStat.CalcParam.ReWin); 
end

%------------------------------local functions-------------------------------
function Dur = CalcWinDur(Win)

Df = diff(Win);
Dur = sum(Df(1:2:end));