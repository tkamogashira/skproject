function RAPStat = NextRAPPlot(RAPStat, LayType)
%NextRAPlot    set RAP status structure to next plot
%   RAPStat = NextRAPPlot(RAPStat)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 04-02-2004

if (nargin == 2)
    Layout = GetRAPLayout(RAPStat, LayType);
else
    Layout = GetRAPLayout(RAPStat);
end

Vec = RAPStat.PlotParam.Figure.CurAx;
Vec(1) = Vec(1) + 1;

if Vec(1) > Layout(1)
    Vec(1) = 1;
    Vec(2) = Vec(2) + 1;
end
if Vec(2) > Layout(2)
    RAPStat = NewRAPFigure(RAPStat);
else
    RAPStat.PlotParam.Figure.CurAx = Vec;
end
