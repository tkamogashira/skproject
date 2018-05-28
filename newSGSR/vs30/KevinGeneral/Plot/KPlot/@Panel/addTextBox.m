function panel = addTextBox(panel, textBox, doRedraw)
% ADDTEXTBOX adds a textBox to the given Panel, and redraws.
%
% panel = addTextBox(Panel panel, textBoxObject textBox, 'noredraw') 
% Adds textBox to panel.
%     
%      panel : A Panel instance we want to add a textBox object to
%    textBox : The textBox object we want to add to panel
%  'noredraw': (optional) If this string is added to the argument list, the
%              plot is not redrawn. This might speed up things when adding
%              much information to a Panel.
%
% Returns: panel, with textBox added to it.
% 
% Example: 
%  >> textBox = textBoxObject('konijn');
%  >> panel = Panel;
%  >> panel = addTextBox(panel, textBox);

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
            error('Only two argumens expected, unless an extra ''noredraw'' is given. Type ''help addTextBox'' for more information.');
        end
    otherwise
        error('This function expects two or three arguments. Type ''help addTextBox'' for more information.');
end

%% add the plot and redraw
if ~( isequal('textBoxObject', class(textBox)) || isequal('HeaderObject', class(textBox)) )
    error('addTextBox only accepts textboxes.');
end

panel.textObjects{end+1} = textBox;
if isequal(1,doRedraw)
    panel = redraw(panel);
end