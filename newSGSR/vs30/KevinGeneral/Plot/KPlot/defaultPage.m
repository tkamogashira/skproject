function fig = defaultPage(name)
% DEFAULTPAGE  Returns a maximized A4 figure, compliant to the lab standards.
%
% fig = defaultPage()
% fig = defaultpage(name) sets the name of the window

%% ---------------- CHANGELOG -----------------------
%  Fri Mar 11 2011  Abel   
%   - Removed resize function since this deletes the legend from plots and
%   seems overkill in general. The resize function now defaults to matlab's
%   doParentResize
%  Tue Jun 7 2011  Abel   
%   - Re-added resize handling (needed for font zooms function in
%     legendObjects().
%   - Changed size of default figure for headerObject plotting

%% Parameters
if nargin < 1 || ~ischar(name)
    name = '';
end

%% define defaults 
% properties are the same as figure properties
% refer to 'doc figure' for more information.
defaults.name               = name;
defaults.numberTitle        = 'off';
defaults.units              = 'normalized';
%defaults.OuterPosition      = [0 0.075 1 0.925]; %Maximize figure
defaults.OuterPosition      = [0.030 0 0.870 1]; %Maximize figure
defaults.PaperType          = 'A4';
%defaults.PaperPositionMode  = 'auto';  %If this is "auto" Matlab
%                                       resizes the figure itself and the
%                                       resize function is ignored.
defaults.PaperPositionMode  = 'manual';
defaults.PaperUnits         = 'normalized';
defaults.PaperPosition      = [0.05 0.05 0.90 0.90];
defaults.PaperOrientation   = 'landscape';

%by Abel: use default resize function
defaults.ResizeFcn          = @resizefcn;

%This tag is needed for the Panel() redraw function and others within Kplot
defaults.Tag                = 'defaultpage';

%% return figure
figureString = 'figure(';

fieldNames = fieldnames(defaults);
for i = 1:length(fieldNames)
    figureString = [figureString '''' fieldNames{i} ...
        ''', defaults.(fieldNames{' int2str(i) '}), '];
end
figureString = [figureString(1:end-2) ');'];

fig = eval(figureString);

%% ResizeFcn
function resizefcn(src, evt) %#ok evt not used but 
panels = get(src,'UserData');
for n = 1:length(panels)
	
	%by Abel: function to redraw objects within the panel() directly. This
	%was needed only for legendObjects to zoom text. Only panal() obejects
	%which have their RedrawOnResize=true are redrawn.
    panels{n} = resize(panels{n});
end
set(src,'UserData',panels);
