function limits = getDataLimits(patchPlot)
% GETDATALIMITS get X and Y extremities for the data
%
% [xlim; ylim] = getDataLimits(PatchPlotObject patchPlot) 
% Gets X and Y extremities for the data
%     
%        patchPlot : An PatchPlotObject instance
%
% Returns: [xlim(1), xlim(2); ylim(1), ylim(2)]
% 
% Example: 
%  >> limits = getDataLimits(patchPlot);

% Created by: Kevin Spiritus

if ~isequal(1, nargin)
    error('getDataLimits takes one argument.');
end

xLimits = [+inf, -inf];
YLimits = [+inf, -inf];
for cPlot = 1:patchPlot.nPlots
    xLimits(1) = min([xLimits(1), min(patchPlot.XData{cPlot})])
    xLimits(2) = max([xLimits(2), max(patchPlot.XData{cPlot})])
    yLimits(1) = min([yLimits(1), min(patchPlot.YData{cPlot})])
    yLimits(2) = max([yLimits(2), max(patchPlot.YData{cPlot})])
end

limits = [xLimits; yLimits];