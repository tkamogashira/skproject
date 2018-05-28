function panel = deleteLegend(panel, boxID, varargin)
% deleteLegend  deletes a legend from a Panel instance
%
% Panel panel = deleteLegend(Panel panel, int boxID, 'noredraw')
%  Deletes legend with index boxID from panel. Indices are counted in the
%  order legend objects are added to panel.
%
% Panel panel = deleteLegend(Panel panel, double Hdl, 'noredraw')
%  Deletes the legend with given handle from panel.
%
% Unless an argument 'noredraw' is given to the command, panel is redrawn
% after deleting a plot.


%% ---------------- CHANGELOG -----------------------
%  Tue Apr 19 2011  Abel   
%   Initial creation based on code of Kevin Spiritus


%% Check params
doRedraw = 1;
switch nargin
	case 2
		% keep standards
	case 3
		if isequal('noredraw', varargin{1})
			doRedraw = 0;
		else
			error('Syntax error.');
		end
	otherwise
		error('This function expects two or three arguments.');
end

if ~isnumeric(boxID)
	error('boxID should be numeric.');
end

%% delete legend
if  isequal(0, mod(boxID, 1) ) %boxID is whole number: remove that legend object from array
	if boxID > size(panel.legendObjects, 2)
		error('The legend instance your are trying to delete does not exist.');
	end
	panel.legendObjects = {panel.legendObjects{1:boxID-1} panel.legendObjects{boxID+1:end}};
else    % a legend handle is given
	% we don't know to which legend this handle belongs; get each
	% legend's handle until we find the right one.
	nObjects = size(panel.legendObjects, 2);
	plotDeleted = 0;
	for i = 1:nObjects
		if isequal(boxID, getHandle(panel.legendObjects{i}))
			panel.legendObjects = {panel.legendObjects{1:boxID-1} panel.legendObjects{boxID+1:end}};
			plotDeleted = 1;
			break;
		end
	end
	if ~isequal(1, plotDeleted)
		error('Given legend could not be deleted. Handle does not exist or is no member of this Panel.');
	end
end

if isequal(1,doRedraw)
	panel = redraw(panel);
end