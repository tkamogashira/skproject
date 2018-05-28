function panel = addLegend(panel, legend, doRedraw)
% addLegend adds a legend to the given Panel, and redraws.
%
% panel = addLegend(Panel panel, legendObject legend, 'noredraw') 
% Adds legend to panel.
%     
%      panel : A Panel instance we want to add a legend object to
%    legend : The legend object we want to add to panel
%  'noredraw': (optional) If this string is added to the argument list, the
%              plot is not redrawn. This might speed up things when adding
%              much information to a Panel.
%
% Returns: panel, with legend added to it.
% 
% Example: 
%  >> legend = legendObject('konijn');
%  >> panel = Panel;
%  >> panel = addLegend(panel, legend);

% Created by: Kevin Spiritus
% Last edited: April 25th, 2007

%% Check params
switch nargin
    case 2
        doRedraw = 1;
    case 3
        if isequal('noredraw', doRedraw)
            doRedraw = 0;
        else
            error('Only two argumens expected, unless an extra ''noredraw'' is given. Type ''help addLegend'' for more information.');
        end
    otherwise
        error('This function expects two or three arguments. Type ''help addLegend'' for more information.');
end

%% add the plot and redraw
if ~( isequal('legendObject', class(legend)) || isequal('HeaderObject', class(legend)) )
    error('addLegend only accepts legendObjects (or HeaderObjects).');
end

panel.legendObjects{end+1} = legend;
if isequal(1,doRedraw)
    panel = redraw(panel);
end