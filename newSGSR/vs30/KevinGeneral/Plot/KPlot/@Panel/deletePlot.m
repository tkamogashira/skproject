function panel = deletePlot(panel, plotID, varargin)
% DELETEPLOT  deletes a plot from a Panel instance
%
% Panel panel = deletePlot(Panel panel, int plotID, 'noredraw')
%  Deletes plotObject with index plotID from panel. Indices are counted in
%  the order plotObjects are added to panel.
%
% Panel panel = deletePlot(Panel panel, int plotID, int subPlotID, 'noredraw')
%  Does the same as previous syntax, but now only a certain subplot of the
%  plotObject is deleted. Again, indices are counted in the order plots
%  were added to the plotObject.
%
% Panel panel = deletePlot(Panel panel, double handle, 'noredraw')
%  Deletes the plot with given handle from panel.
%
% Unless an argument 'noredraw' is added to the command, panel is redrawn
% after deleting a plot.

% Created by: Kevin Spiritus
% Last adjustment: April 26th, 2006

%% Check params
doRedraw = 1;
subPlotID = 0;
switch nargin
    case 2
        % keep standards
    case 3
        if isequal('noredraw', varargin{1})
            doRedraw = 0;
        elseif isnumeric(varargin{1}) && isequal(0, mod(varargin{1}, 1))
            subPlotID = varargin{1};
        else
            error('Syntax terror.');
        end
    case 4
        if isnumeric(varargin{1}) && isequal(0, mod(varargin{1}, 1))
            subPlotID = varargin{1};
        else
            error('Syntax error.');
        end

        if ~isequal('noredraw',  varargin{2})
            doRedraw = 0;
        else
            error('Syntax error.');
        end
    otherwise
        error('This function expects two or three arguments.');
end

if isequal(0, mod(plotID, 1) ) %plotID is whole number: remove that plotObject or subPlot from array
    if plotID > size(panel.plotObjects, 2)
        error('The plot your are trying to delete does not exist.');
    end
    if isequal(0, subPlotID) %delete the whole object if no subPlotID given
        panel.plotObjects = {panel.plotObjects{1:plotID-1} panel.plotObjects{plotID+1:end}};
    else %or delete just the given subPlot
        panel.plotObjects{plotID} = deletePlot(panel.plotObjects{plotID}, subPlotID);
    end
else
    % a plot handle is given; subPlotID must be zero
    if ~isequal(0, subPlotID)
        error ('When giving a plot handle, no subPlotID must be given.');
    end
    
    % we don't know in which plotObject the handle is; just try to delete
    % it in every plotObject, and ignore errors. if one object does not
    % throw an error, it contained the handle and we're ok.
    plotDeleted = 0;
    nObjects = size(panel.plotObjects, 2);
    for i = 1:nObjects 
        try
            panel.plotObjects{i} = deletePlot(panel.plotObjects{i}, plotID);
            %this point is only reached when a plot is effectively deleted
            plotDeleted = 1;
            break;
        catch
            %an error is thrown by deletePlot if the handle doesn't exist
            %just ignore the error
        end
    end
    if ~isequal(1, plotDeleted)
        error('Given plot could not be deleted. Handle does not exist or is no member of this Panel.');
    end
end

if isequal(1,doRedraw)
    panel = redraw(panel);
end