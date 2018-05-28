function newTextBox = textBoxObject(text, varargin)
% TEXTBOXOBJECT Creates a textBoxObject instance.
%
% newTextBox = textBoxObject(text, paramList) 
% Creates an textBoxObject object from the given text. Parameter pairs can be
% given in paramList.
%
%                 text: The text that will appear in the textBoxObject.
%      BackgroundColor: Background color of the textBoxObject.
%                       Specify 'none' for transparant.
%            EdgeColor: Color of the border.
%                Color: A three-element RGB vector or one of the predefined
%                       names, specifying the text color.
%  HorizontalAlignment: left | center | right
%            LineStyle: Border property: - | -- | : | -. | none
%            LineWidth: Width of the border.
%               Margin: The distance in pixels between the text and the
%                       border.
%             Position: Either a 1x2 numeric array (in units normalized to 
%                       the axes), or one of the following strings:
%                         'North'              inside plot box near top
%                         'South'              inside bottom
%                         'East'               inside right
%                         'West'               inside left
%                         'NorthEast'          inside top right (default)
%                         'NorthWest           inside top left
%                         'SouthEast'          inside bottom right
%                         'SouthWest'          inside bottom left
%    VerticalAlignment: top | cap | middle | baseline |  bottom
%           FontWeight: light | normal | demi | bold
%             FontSize: integer number of points
%             Rotation: Rotation of the text box.


% Created by: Kevin Spiritus
% Last edited: December 7th, 2006

%% ---------------- CHANGELOG -----------------------
%  Wed Jun 8 2011  Abel   
%   - Added Matlab plotting options 
%   - Adapted to be able to use FontUnits = 'normalized' -> enable font auto
%     resize 


%% Parameter checking
% internals
newTextBox.text = [];
newTextBox.hdl = 0;
newTextBox.size = 0;
% define structure of parameters: just fill with defaults
newTextBox.params.ML.BackgroundColor       = 'w';
newTextBox.params.ML.EdgeColor             = 'k';
newTextBox.params.ML.Color                 = 'k';
newTextBox.params.ML.HorizontalAlignment   = 'left';
newTextBox.params.ML.LineStyle             = '-';
newTextBox.params.ML.LineWidth             = 1;
newTextBox.params.ML.Margin                = 1;
newTextBox.params.ML.Position              = 'NorthEast';
newTextBox.params.ML.VerticalAlignment     = 'middle';
newTextBox.params.ML.FontWeight            = 'normal';
newTextBox.params.ML.FontSize              = 7; %in Points 
newTextBox.params.ML.FontUnits             = 'normalized'; %Enabled after drawing of box: see redraw()
newTextBox.params.ML.Rotation              = 0;

%redraw box on resize 
newTextBox.params.RedrawOnResize = false;

% by abel: if zero arguments, return the defaults
if nargin < 1
	newTextBox = class(newTextBox, 'textBoxObject');
	return;
end

% check text and additional arguments
if ~ischar(text)
    % could be a vertcat of strings
    if ~iscell(text) || ~isequal(1, size(text, 2))
        error(['First argument of textBoxObject constructor should be text.' ...
            'Type ''help textBoxObject'' for more information.']);
    else
        for i = 1:size(text, 1)
            if ~ischar(text{i})
                error(['First argument of textBoxObject constructor should ' ...
                    'be text. Type ''help textBoxObject'' for more information.']);
            end
        end
    end
end

paramsIn = varargin; % these will be checked later, by processParams

%% Assign data
newTextBox.text = text;
newTextBox.hdl = 0;
newTextBox.size = 0;

%% Handle parameters
% Parameters given as arguments are placed in the params structure.
newTextBox.params = processParams(paramsIn, newTextBox.params);

%% Return object
newTextBox = class(newTextBox, 'textBoxObject');
