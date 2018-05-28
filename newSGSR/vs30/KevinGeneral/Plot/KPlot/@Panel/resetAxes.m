function panel = resetAxes(panel)
% RESETFIGURE Resets the axes of a KPlotObject
% KPlotObject panel = resetAxes(KPlotObject panel)
% If no axes exists for panel, create a new one.

% Created by: Kevin Spiritus
% Last edited: 2007/03/12

try
    findobj(panel.hdl);
catch
    panel.hdl = gca; % if handles doesn't exist, create new one
end

if ~isequal([0 0 0 0], panel.params.position)
    set(panel.hdl, 'position', panel.params.position);
end