function panel = addPlot(panel, plotObject, doRedraw)
% ADDPLOT adds plotObject to the given Panel instance, and redraws
%
% panel = addPlot(KPlotObject panel, plotObject P, 'noredraw') 
% adds the plot P to KPlotObject instance panel.
%     
%      panel : A Panel instance we wish to add a plot object to.
%          P : The plot object we want to add to panel. This can
%              be, among others, an XYPlotObject or a WFPlotObject. 
%  'noredraw': (optional) If this string is added to the argument list, the
%              plot is not redrawn. This might speed up things when
%              constructing large plots.
%
% Returns: panel, with P added to it.
% 
% Example: 
%  >> P = XYPlotObject(0:0.01:2*pi, sin(0:0.01:2*pi));
%  >> panel = Panel;
%  >> panel = addPlot(panel, P);

% Created by: Kevin Spiritus
% Last adjustment: April 25th, 2007

%% Check params
switch nargin
    case 2
        doRedraw = 1;
    case 3
        if isequal('noredraw', doRedraw)
            doRedraw = 0;
        else
            error(['Only two argumens expected, unless an extra ''noredraw'''...
                ' is given. Type ''help addPlot'' for more information.']);
        end
    otherwise
        error(['This function expects two or three arguments.'...
            ' Type ''help addPlot'' for more information.']);
end

%% add the plot and redraw
panel.plotObjects{end+1} = plotObject;
if isequal(1,doRedraw)
    panel = redraw(panel);
end
