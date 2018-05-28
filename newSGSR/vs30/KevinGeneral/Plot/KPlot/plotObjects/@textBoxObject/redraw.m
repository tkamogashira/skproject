function textBoxObject = redraw(hdl, textBoxObject)
% REDRAW Draws a textBoxObject on the given handle.
%
% textBoxObject = redraw(hdl, textBoxObject)
% Redraws the given textBoxObject, and returns the new textBoxObject.
%
%      hdl: The handle on which you want to plot the textBoxObject. Typically a
%           figure or an axes.

%% ---------------- CHANGELOG -----------------------
%  Wed Jun 8 2011  Abel   
%   - Set font units after initial box creation. This allows users to set
%     the font size in points initially and enable auto resize by setting
%     the font units to normalized after creation of the textbox().

%% Check arguments
% number of arguments
if ~isequal(2, nargin)
    error('Incorrect number of arguments.');
end

% check given handle
try
    findobj(hdl);
catch objErr
    error('Given handle for drawing textBoxObject is invalid. Type ''help redraw'' for more information.');
end

if ~isequal('textBoxObject', class(textBoxObject))
    error('Second argument should be a textBoxObject instance.');
end

% copy params from textBoxObject instance to avoid changing things
params = textBoxObject.params;

%% Plot
% We have problem here: to determine the position for plotting, we need to
% know the size of the textBoxObject. We can't know the size though before we
% actually plot the textBoxObject. To solve this problem, we first plot the text
% at position (0, 0), then determine the size, and then reposition the
% textBoxObject.

% position could still be a string (e.g. 'northeast'). Temporarily store
% it's value and replace it by [0 0].
tempPos = params.ML.Position;
params.ML.Position = [0 0];
axes(hdl);

% Run through the plot parameters and build a string for the plot
% command
TBFieldNames = fieldnames(params.ML);
paramString = '';
for FNCounter = 1:size(TBFieldNames, 1)
	if ~strcmpi(TBFieldNames{FNCounter}, 'FontUnits') %by Abel: Skip FontUnits -> we'll need to set 'FontUnits', 'normalized' later on
		paramString = [paramString ', ''' TBFieldNames{FNCounter} ''', params.ML.(TBFieldNames{' int2str(FNCounter) '})'];
	end
end

plotString = 'textBoxObject.hdl = text(''String'', textBoxObject.text, ''units'', ''normalized''';
plotString = [plotString paramString ');'];

eval(plotString);

% restore position
params.ML.Position = tempPos; 

TBExtent = get(textBoxObject.hdl, 'extent');
textBoxObject.size = TBExtent(3:4);

%% Handle position
% since we are lazy and prefer short notations:
position = params.ML.Position;
valign = textBoxObject.params.ML.VerticalAlignment; % work with the original values: only override when 'def'

% If position is a string, original valign is overridden.
if ischar(position)
    position = lower(position);
    switch position
        case 'north'              %inside plot box near top
            valign = replaceDef(valign, 'top');
            position = [0.5-textBoxObject.size(1)/2 0.95];
        case 'south'              %inside bottom
            valign = replaceDef(valign, 'bottom');
            position = [0.5-textBoxObject.size(1)/2 0.05];
        case 'east'               %inside right
            valign = replaceDef(valign, 'middle');
            position = [0.98-textBoxObject.size(1) 0.5];
        case 'west'               %inside left
            valign = replaceDef(valign, 'middle');
            position = [0.02 0.5];
        case 'northeast'          %inside top right (default)
            valign = replaceDef(valign, 'top');
            position = [0.98-textBoxObject.size(1) 0.95];
        case 'northwest'          %inside top left
            valign = replaceDef(valign, 'top');
            position = [0.02 0.95];
        case 'southeast'          %inside bottom right
            valign = replaceDef(valign, 'bottom');
            position = [0.98-textBoxObject.size(1) 0.05];
        case 'southwest'          %inside bottom left
            valign = replaceDef(valign, 'bottom');
            position = [0.02 0.05];
        otherwise
            error('Position string in textBoxObject contains an error!');
    end
end

if ~isequal([1 2], size(position)) || ~isnumeric(position)
    error('Position array is not formatted as it should be. Expected string or 1x2 numeric array.');
end

% change back:
params.ML.Position = position;
params.ML.VerticalAlignment = valign;

% reposition textBoxObject
set(textBoxObject.hdl, 'VerticalAlignment', valign, 'Position', position);

% by abel: Set to normalized to scale FontSize automatically
if isfield(params.ML, 'FontUnits')
	set(textBoxObject.hdl, 'FontUnits', params.ML.FontUnits);
end

