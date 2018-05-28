function [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData, FieldName)
%SetRAPYLim   set upper limits for ordinate of multiple RAP plots
%   [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, CalcData, FieldName)
%   [PlotStruct, ErrTxt] = SetRAPYLim(RAPStat, PlotStruct, YData)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 04-05-2004

ErrTxt  = '';
YMargin = RAPStat.PlotParam.Axis.Y.Margin;
NPlots  = length(PlotStruct);

if (nargin == 3), MaxVal = max(CalcData(:));
else, MaxVal = max(eval(sprintf('cat(2, CalcData.%s)', FieldName))); end   

if isinf(RAPStat.PlotParam.Axis.Y.Limits(2)),
    for n = 1:NPlots, PlotStruct(n).Axis.Y.Limits(2) = MaxVal*(1+YMargin); end
end