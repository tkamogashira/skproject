function limits = getDataLimits(XYP)
% GETDATALIMITS get X and Y extremities for the data
%
% [xlim; ylim] = getDataLimits(XYPlotObject XYP) 
% Gets X and Y extremities for the data
%     
%        XYP : An XYPlotObject instance
%
% Returns: [xlim(1), xlim(2); ylim(1), ylim(2)]
% 
% Example: 
%  >> limits = getDataLimits(xyp);

% Created by: Kevin Spiritus

if ~isequal(1, nargin)
    error('getDataLimits takes one argument.');
end

xLimits = [+inf, -inf];
yLimits = [+inf, -inf];
for cPlot = 1:nPlots(XYP)
    xLimits(1) = min([xLimits(1), min(XYP.XData{cPlot})]);
    xLimits(2) = max([xLimits(2), max(XYP.XData{cPlot})]);
    yLimits(1) = min([yLimits(1), min(XYP.YData{cPlot})]);
    yLimits(2) = max([yLimits(2), max(XYP.YData{cPlot})]);
end

limits = [xLimits; yLimits];