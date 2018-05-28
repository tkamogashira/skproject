function WFPlotObject = deletePlot(WFPlotObject, ID)
% DELETEPLOT Delete the plot with the given handle
%
% WFPlotObject = deletePlot(WFPlotObject, hdl)
%
%  hdl: handle or index of the plot that is to be deleted. The indices
%       are in the order the plots were added.

% Created by: Kevin Spiritus
% Last edited: December 14th, 2006

% build keepPos, an array with positions we wish to keep
if isequal(0, mod(ID, 1)) % ID is a plot index
    keepPos = [1:(ID-1) (ID+1):size(WFPlotObject.plotHdl)];
else % ID is a plot handle
    keepPos = find(WFPlotObject.plotHdl ~= ID);
end

if isequal(size(keepPos), size(WFPlotObject.plotHdl))
% this means we are trying to keep everything
    error('The plot you are trying to delete does not exist. Type ''help deletePlot'' for more information');
end

WFPlotObject.XData = {WFPlotObject.XData{keepPos}}';
WFPlotObject.YData = {WFPlotObject.YData{keepPos}}';
WFPlotObject.ZData = {WFPlotObject.ZData{keepPos}}';
if ~isempty(WFPlotObject.hdls)
    WFPlotObject.hdls = WFPlotObject.hdls(keepPos);
end
newWFPlot.params = keepPropertyRow(WFPlotObject.params, keepPos);