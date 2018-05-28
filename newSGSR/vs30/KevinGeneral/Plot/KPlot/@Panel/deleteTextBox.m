function panel = deleteTextBox(panel, boxID, varargin)
% DELETETEXTBOX  deletes a textBox from a Panel instance
%
% Panel panel = deleteTextBox(Panel panel, int boxID, 'noredraw')
%  Deletes textBox with index boxID from panel. Indices are counted in the
%  order textBox objects are added to panel.
%
% Panel panel = deleteTextBox(Panel panel, double Hdl, 'noredraw')
%  Deletes the textBox with given handle from panel.
%
% Unless an argument 'noredraw' is given to the command, panel is redrawn
% after deleting a plot.

% Created by: Kevin Spiritus
% Last edited: December 14th, 2006

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

%% delete textBox
if  isequal(0, mod(boxID, 1) ) %boxID is whole number: remove that textBox object from array
    if boxID > size(panel.textObjects, 2)
        error('The textBox instance your are trying to delete does not exist.');
    end
    panel.textObjects = {panel.textObjects{1:boxID-1} panel.textObjects{boxID+1:end}};
else    % a textBox handle is given
    % we don't know to which textBox this handle belongs; get each
    % textBox's handle until we find the right one.
    nObjects = size(panel.textObjects, 2);
    plotDeleted = 0;
    for i = 1:nObjects 
        if isequal(boxID, getHandle(panel.textBoxObjects{i}))
            panel.textObjects = {panel.textObjects{1:boxID-1} panel.textObjects{boxID+1:end}};
            plotDeleted = 1;
            break;
        end
    end
    if ~isequal(1, plotDeleted)
        error('Given textBox could not be deleted. Handle does not exist or is no member of this Panel.');
    end
end

if isequal(1,doRedraw)
    panel = redraw(panel);
end