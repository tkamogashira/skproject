function nPlots = nPlots(XYPlotObject)
% NPLOTS returns the amount of plots in the given XYPlot object
%
% nPlots = nPlots(XYPlotObject)

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006

nPlots = size(XYPlotObject.XData, 1);