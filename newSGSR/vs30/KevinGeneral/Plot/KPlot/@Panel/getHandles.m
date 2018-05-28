function hdls = getHandles(panel)
% GETHANDLES returns the handles of the Panel object
%
% hdls = getHandles(Panel panel)
% Returns an array with all plot handles, in the order they were added to
% the panel. If a plot object in panel contains multiple plots, they will
% be returned in the order they were passed to the constructor of that plot
% object.

% Created by: Kevin Spiritus
% Last edited: April 26th, 2007

nObjects = size(panel.plotObjects, 2);
hdls = [];
for i = 1:nObjects
    hdls = [hdls getHandles(panel.plotObjects{i})];
end