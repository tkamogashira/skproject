function hdls = getHandles(XYPlotObject)
% GETHANDLES returns the handles of the XYPlot object
%
% double[] hdls = getHandles(XYPlotObject P)
% Handles are returned in the order they were created in.

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006

hdls =  XYPlotObject.plotHdl;