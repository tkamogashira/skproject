function hdls = getHandles(HistPlotObject)
% GETHANDLES returns the handles of the HistPlot object
%
% double[] hdls = getHandles(HistPlotObject P)
% Handles are returned in the order they were created in.

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006

hdls =  HistPlotObject.plotHdl;