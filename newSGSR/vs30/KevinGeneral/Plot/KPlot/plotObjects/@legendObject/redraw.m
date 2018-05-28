function legendObject = redraw(legendObject, panel)
% REDRAW Draws a legendObject on the given handle.
%
% legendObject = redraw(panel, legendObject)
% Redraws the given legendObject, and returns the new legendObject.
%
%      panel: The panel on which you want to plot the legendObject.
% 
% SEE ALSO	legend legendObject panel

%% ---------------- CHANGELOG -----------------------
%  Tue Apr 19 2011  Abel   
%   Initial creation based on code of Kevin Spiritus

%% Check arguments
% number of arguments
if ~isequal(2, nargin)
    error('Incorrect number of arguments.');
end

% check given objects
if ~isequal('legendObject', class(legendObject))
    error('First argument should be a legendObject instance.');
end
if ~isequal('Panel', class(panel))
    error('Second argument should be a Panel instance.');
end


%% Set some usefull params
% Get linear idx for X/Y data we want in the legend
visIdx = find(~cellfun(@isempty,legendObject.params.textlabels));

% Get handles for legend
legHandles = getHandles(panel);
legHandles = legHandles(visIdx);
if isempty(legHandles)
	error('Can''t find handles to draw legend on (was the panel drawn?)');
end

% Get labels as row vectors
plotLabels = legendObject.params.textlabels(visIdx)';

% copy params from legendObject instance to avoid changing things
params = legendObject.params;

%% Plot
% If we are replotting (i.e. resize figure), lets adapt the fontsize to
% zoom in/out
% - This is a replot if the handle exists
isRedraw = legendObject.hdl ~= 0;
% - Get width 
if isRedraw
	oldWidth = legendObject.size;
	oldWidth = oldWidth(1);
	delete(legendObject.hdl);
end

% Run through the plot parameters and build a string for the plot
TBFieldNames = fieldnames(params.ML);
paramString = [];
for FNCounter = 1:size(TBFieldNames, 1)
    paramString = [paramString ', ''' TBFieldNames{FNCounter} ''', params.ML.(TBFieldNames{' int2str(FNCounter) '})'];
end
plotString = [ ...
	'legendObject.hdl = legend(legHandles, plotLabels '...
	paramString...
	');'];

% plot the legend
eval(plotString);

% If this is a replot, zoom the fontsize 
if isRedraw
	%Get original font size. 
	% - Change the fontSize only to smaller values then the original size given
    %   in legendObject(). The fontUnit is alway 'points'.
	oldFontSize = get(legendObject, 'FontSize');

	%Get new font size
	set(legendObject.hdl, 'FontUnits', 'points');
	fontSize = get(legendObject.hdl, 'FontSize');
	
	%Get new width
	legSize = get(legendObject.hdl, 'Position');
	newWidth = legSize(3);
	
	%Calc new font size: zoomFact = oldWidth/newWidth;
	fontSize = (oldWidth/newWidth) * fontSize;
	
	%Set new font size if ori size => new size
	if fontSize <= oldFontSize
	 	set(legendObject.hdl, 'FontSize', fontSize); 
	else
		set(legendObject.hdl, 'FontSize', oldFontSize); 
	end
	
	%CAN SET FONTSIZE BUT NOT Units without screwing things up?
	%set(legendObject.hdl, 'FontUnits', oldFontUnit); 
	%CAN'T RESET FONTUNITS screws up printing for some reason? 
end

% Save size
legSize = get(legendObject.hdl, 'Position');
legendObject.size = [legSize(3) legSize(4)];
end
