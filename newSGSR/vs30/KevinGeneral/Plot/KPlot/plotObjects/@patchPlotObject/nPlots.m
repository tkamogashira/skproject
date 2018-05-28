function nPlots = nPlots(PPlot)
% NPLOTS returns the number of plots in the given PatchPlot object
%
% nPlots = nPlots(PatchPlotObject)

% Created by: Kevin Spiritus
% Last edited: January 10th, 2006

nPlots = size(PPlot.XData, 1);