function limits = getDataLimits(histPlot)
% GETDATALIMITS get X and Y extremities for the data
%
% [xlim; ylim] = getDataLimits(HistPlotObject histPlot)
% Gets X and Y extremities for the data
%
%        histPlot : A HistPlotObject instance
%
% Returns: [xlim(1), xlim(2); ylim(1), ylim(2)]
%
% Example:
%  >> limits = getDataLimits(histPlot);

% Created by: Kevin Spiritus

if ~isequal(1, nargin)
    error('getDataLimits takes one argument.');
end

xLimits = [+inf, -inf];
yLimits = [+inf, -inf];

xLimits(1) = min([xLimits(1), min(histPlot.XData)]);
xLimits(2) = max([xLimits(2), max(histPlot.XData)]);
yLimits(1) = min([yLimits(1), min(histPlot.YData)]);
yLimits(2) = max([yLimits(2), max(histPlot.YData)]);

limits = [xLimits; yLimits];