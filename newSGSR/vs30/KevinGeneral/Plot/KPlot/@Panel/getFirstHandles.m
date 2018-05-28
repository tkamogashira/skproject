function hdls = getFirstHandles(panel)
% GETHANDLES returns the first handles of the Panel object
%
% hdls = getHandles(Panel panel)
% Returns an array with the first plot handle from each plot object, in the
% order they were added to the panel. 

% Created by: Kevin Spiritus
% Last edited: February 11th, 2008

nObjects = size(panel.plotObjects, 2);
hdls = zeros(nObjects, 1);
for i = 1:nObjects
    objectHdls = getHandles(panel.plotObjects{i});
    if isempty(objectHdls)
        objectHdls = NaN;
    end
    hdls(i) = objectHdls(1);
end