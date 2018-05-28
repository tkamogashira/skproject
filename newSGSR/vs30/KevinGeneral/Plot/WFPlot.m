function Hdl = WFPlot(XData, YData, ZData, varargin)
% WFPLOT Create and plot a waterfall plot.
%
% A waterfall plot resembles a normal XY plot. The Y coordinates though are
% shifted by an aditional Z coordinate.
%
% Hdl = WFPlot(XData, YData, ZData, params)
% Create a waterfall plot from the given data.
%
% Arguments:
%   XData: A column cell array or a 2 dimensional numeric array, containing
%          the X values for each plot. Each row contains data for another
%          plot, to appear on the same axes.
%   YData: A column cell array or a 2 dimensional numeric array, containing
%          the Y values for each plot. Each row contains data for another
%          plot, to appear on the same axes. XData and YData should have the
%          same size.
%   ZData: A column cell array or a column numeric vector, containing
%          the Z values for each plot. ZData should contain the same number
%          of rows as XData and YData. For each row, the YData is shifted by
%          the resepctive number in ZData.
%  Params: A list of 'paramName', paramValue entries. 
%          * Standard Matlab properties:
%            These properties can be given as column cell arrays, with a
%            value for each row, or as single values, being used for the
%            whole plot.
%            More information about the parameters can be found by typing
%            'doc plot'.
%             Property:       Default:
%              Marker          'x'
%              LineStyle       '-'
%              LineWidth       0.5
%              Color           ''
%          * Custom properties:
%             Property:       Default:     Meaning:
%              scale           1            The scale of the plots.
%              plotScale       'yes'        Draw a scale? 'yes' or 'no'
%              scaleRow        1            At which row to draw the scale.
%          * An extra mode was added for MarkerFaceColor, the mode 'fill'
%            sets the MarkerFaceColor to the value of Color
% Examples:
%  >> t = 0:0.01:100;
%  >> subplot(121)
%  >> WFPlot([t;t], [sin(t);cos(t)], [-2;2], 'Marker', 'none', 'color', {'b';'y'}, 'scale', 1.5, 'scaleRow', 2)
%  >> subplot(122)
%  >> WFPlot({0:0.01:100;10:0.01:90}, {sin(0:0.01:100);cos(10:0.01:90)}, {-1;1}, 'marker', 'none', 'scale', 0.75)
         
panel = Panel;
WFP = WFPlotObject(XData, YData, ZData, varargin);
panel = addPlot(panel, WFP);
redraw(panel);
Hdl = getHdl(panel);