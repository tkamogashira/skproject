function Hdl = getHdl(panel)
% GETHDL Gets the handle of the given Panel instance.
%
% Hdl = getHdl(panel)
% Gets the handle of the axes that was used for panel.
%
% To get the handles of subplots, use getHandles(panel).

% Created by: Kevin Spiritus
% Last edited: 06/12/2006

Hdl = panel.hdl;