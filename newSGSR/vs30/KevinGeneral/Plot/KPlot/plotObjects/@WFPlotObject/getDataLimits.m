function limits = getDataLimits(WFP)
% GETDATALIMITS get X and Y extremities for the data
%
% [xlim; ylim] = getDataLimits(WFPlotObject WFP) 
% Gets X and Y extremities for the data
%     
%        WFP : An WFPlotObject instance
%
% Returns: [xlim(1), xlim(2); ylim(1), ylim(2)]
% 
% Example: 
%  >> limits = getDataLimits(wfp);

% Created by: Kevin Spiritus

if ~isequal(1, nargin)
    error('getDataLimits takes one argument.');
end

xLimits = [+inf, -inf];
YLimits = [+inf, -inf];
for cPlot = 1:WFP.nPlots
    xLimits(1) = min([xLimits(1), min(WFP.XData{cPlot})])
    xLimits(2) = max([xLimits(2), max(WFP.XData{cPlot})])
    yLimits(1) = min([yLimits(1), min(WFP.YData{cPlot})])
    yLimits(2) = max([yLimits(2), max(WFP.YData{cPlot})])
end

limits = [xLimits; yLimits];