function XY = deletePlot(XY, ID)
% DELETEPLOT Delete the plot with the given ID
%
% XYPlotObject = deletePlot(XYPlotObject, hdl)
%
%  hdl: handle of the plot that is to be deleted. 

% XYPlotObject = deletePlot(XYPlotObject, idx)
%
%  idx: index of the plot that is to be deleted. The indices are in the
%       order the plots were added. 

% Created by: Kevin Spiritus
% Last edited: April 30th, 2006

% build keepPos, an array with positions we wish to keep
if isequal(0, mod(ID, 1)) % ID is a plot index
    keepPos = [1:(ID-1) (ID+1):size(XY.plotHdl)];
else % ID is a plot handle
    keepPos = find(XY.plotHdl ~= ID);
end

if isequal(size(keepPos), size(XY.plotHdl))
% this means we are trying to keep everything
    error('The plot you are trying to delete does not exist. Type ''help deletePlot'' for more information');
end

XY.XData   = {XY.XData{keepPos}}';
XY.YData   = {XY.YData{keepPos}}';
if ~isempty(XY.plotHdl)
    XY.plotHdl = XY.plotHdl(keepPos);
end
XY.params = keepPropertyRow(XY.params, keepPos);