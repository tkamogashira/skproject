function PP = deletePlot(PP, ID)
% DELETEPLOT Delete plot with given handle
%
% PatchPlotObject = deletePlot(PatchPlotObject, hdl)
%
%  hdl: handle or index of the plot that is to be deleted. The indices
%       are in the order the plots were added.

% Created by: Kevin Spiritus
% Last edited: January 9th, 2006

% build keepPos, an array with positions we wish to keep
if isequal(0, mod(ID, 1)) % integer: ID is a plot index
    keepPos = [1:(ID-1) (ID+1):size(PP.plotHdl)];
else % float: ID is a plot handle
    keepPos = find(PP.plotHdl ~= ID);
end

if isequal(size(keepPos), size(PP.plotHdl))
% this means we are trying to keep everything
    error('The plot you are trying to delete does not exist. Type ''help deletePlot'' for more information');
end

PP.XData   = {PP.XData{keepPos}}';
PP.YData   = {PP.YData{keepPos}}';
if ~isempty(PP.plotHdl)
    PP.plotHdl = PP.plotHdl(keepPos);
end
PP.params = keepPropertyRow(PP.params, keepPos);