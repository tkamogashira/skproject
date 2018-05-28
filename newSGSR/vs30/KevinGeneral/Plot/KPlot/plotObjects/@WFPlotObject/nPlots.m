function nPlots = nPlots(WFP)
% NPLOTS returns the amount of plots in the given WFPlotObject instance.
%
% nPlots = nPlots(WFPlotObject WFP)

% Created by: Kevin Spiritus
% Last edited: December 12th, 2006

nPlots = size(WFP.XData, 1);