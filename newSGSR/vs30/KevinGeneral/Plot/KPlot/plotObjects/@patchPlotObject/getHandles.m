function hdls = getHandles(PatchPlotObject)
% GETHANDLES returns the handles of the PatchPlot object
%
% double[] hdls = getHandles(PatchPlotObject P)
% Handles are returned in the order they were created in.

% Created by: Kevin Spiritus
% Last edited: January 10th, 2006

hdls =  PatchPlotObject.plotHdl;