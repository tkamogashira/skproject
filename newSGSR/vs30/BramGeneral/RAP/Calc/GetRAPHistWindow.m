function Window = GetRAPHistWindow(RAPStat, Type)
%GetRAPHistWindow   get histogram binning window
%   Window = GetRAPHistWindow(RAPStat, Type)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 22-03-2004

Window = RAPStat.PlotParam.Axis.X.Limits;

switch lower(Type)
case 'psth',
    if isinf(Window(1)), Window(1) = 0; end
    if isinf(Window(2)), Window(2) = GetRAPCalcParam(RAPStat, 'nr', 'MaxPST'); end
case 'prdh',
    if isinf(Window(1)), Window(1) = 0; end
    if isinf(Window(2)), Window(2) = 1; end
case 'isih',
    if isinf(Window(1)), Window(1) = 0; end
    if isinf(Window(2)), Window(2) = GetRAPCalcParam(RAPStat, 'nr', 'MaxISI'); end
case 'fslh',
    if isinf(Window(1)), Window(1) = 0; end
    if isinf(Window(2)), Window(2) = GetRAPCalcParam(RAPStat, 'nr', 'MaxFSL'); end
end    