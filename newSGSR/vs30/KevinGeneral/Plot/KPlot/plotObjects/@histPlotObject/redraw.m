function HistPlotObject = redraw(hdl, HistPlotObject, varargin)
% REDRAW Redraws the given plot on the given handle.
%
% HistPlotObject P = Redraw(HistPlotObject P, dbl hdl[, int startColor])
% The plot P is being plotted on the given figure or axes.
%
%           P: The HistPlotObject which is being plotted.
%         hdl: The handle where HistPlotObject is being plotted (typically a figure
%              or an axes).

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006

%% parameters
if isequal(2, nargin)
    startColor = 1;
end

if nargin > 3
    error('Too many arguments.');
end

%% check given handle
try
    findobj(hdl);
catch
    error('Given handle for drawing HistPlotObject is invalid. Type ''help redraw'' for more information.');
end

%% Then plot
axes(hdl);
bar(hdl, HistPlotObject.XData, HistPlotObject.YData, HistPlotObject.params.Color);

