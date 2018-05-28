function panel = redraw(panel)
% REDRAW Redraws the Panel.
%
% redraw(Panel panel)
% This function is mostly used internally, and users only need it when they
% closed the figure and want to see it again.

% Created by: Kevin Spiritus
% Last edited: December 4th, 2006

%% ---------------- CHANGELOG -----------------------
%  Fri Mar 4 2011  Abel   
%   - Added option to keep standard matlab log-scale
%  Tue Apr 19 2011  Abel   
%   - Added legendObject handling 
%%

%% Make sure figure is there
panel = resetAxes(panel);   %sets panel.hdl (= gca handle )

%% Empty the current plot
delete( get(panel.hdl, 'children') );

%% Set the title
axes(getHdl(panel));

title(panel.params.title);
xlabel(panel.params.xlabel);
ylabel(panel.params.ylabel);
if isequal([0 0], panel.params.xlim)
    panel.params.xlim = 'auto';
end
if isequal([0 0], panel.params.ylim)
    panel.params.ylim = 'auto';
end
xlim(panel.params.xlim);
ylim(panel.params.ylim);

%% ticks
mainAxes = gca;
set(mainAxes, 'TickDir', panel.params.ticksDir, 'Box', panel.params.box);
if ~isempty(panel.params.xTicks)
    set(mainAxes, 'XTick', panel.params.xTicks);
end
if ~isempty(panel.params.xTickLabels)
    set(mainAxes, 'XTickLabel', panel.params.xTickLabels)
end
if ~isempty(panel.params.yTicks)
    set(mainAxes, 'YTick', panel.params.yTicks);
end
if ~isempty(panel.params.yTickLabels)
    set(mainAxes, 'YTickLabel', panel.params.yTickLabels)
end

%% if requested, draw right Y-axes
if isequal('yes', lower(panel.params.rightYAxes))
    rightAxes = axes('Position', get(mainAxes, 'position'), 'TickDir', ...
        panel.params.ticksDir, 'YAxisLocation', 'right', 'XTick', [], ...
        'XTickLabel', '', 'YLim', panel.params.ylim, ...
        'YTick', panel.params.rightYPositions, 'YTickLabel', panel.params.rightYLabels);
    set(get(rightAxes, 'YLabel'), 'String', panel.params.rightYLabel);
    set(mainAxes, 'Color', 'none'); % make sure right axes is visible
end

%% set axes logarithmic if asked
switch(panel.params.logX)
    case 'yes'
        set(mainAxes, 'XScale', 'log');
		%by Abel: Set labels for tics X-as
		if isempty(panel.params.xTickLabels) && strcmpi(panel.params.logXformat, 'xlog125')
			xlog125;
		end
		
    case 'no'
        set(mainAxes, 'XScale', 'linear');
    otherwise
        error('Wrong format for logX');
end

switch(panel.params.logY)
    case 'yes'
        set(mainAxes, 'YScale', 'log');
		%by Abel: Set labels for tics Y-as
		if isempty(panel.params.yTickLabels) && strcmpi(panel.params.logYformat, 'ylog125')
			ylog125;
		end
    case 'no'
        set(mainAxes, 'YScale', 'linear');
    otherwise
        error('Wrong format for logY');
end

%% Disable axes if requested
if ~panel.params.axes
    set(mainAxes, 'Visible', 'off');
end

%% Reverse axes if requested
if isequal(panel.params.reverseY, 'yes')
    set(mainAxes, 'YDir', 'reverse');
end
if isequal(panel.params.reverseX, 'yes')
    set(mainAxes, 'XDir', 'reverse');
end

%% Then, plot all plot objects
nPlotObjects = size(panel.plotObjects, 2);
% remember the colors, so all plots can get their own colors
startColor = 1;
for i = 1:nPlotObjects
    panel.plotObjects{i} = redraw(mainAxes, panel.plotObjects{i}, startColor);
    startColor = startColor + nPlots(panel.plotObjects{i});
end

nTextBoxes = size(panel.textObjects, 2);
for i = 1:nTextBoxes
    panel.textObjects{i} = redraw(mainAxes, panel.textObjects{i});
end

%by Abel: add legend objects
nLegends = size(panel.legendObjects, 2);
for i = 1:nLegends
    panel.legendObjects{i} = redraw(panel.legendObjects{i}, panel);
end

%% Add plots to the UserData field of the page
if ~panel.isRegistered
    pages = findobj('Tag','defaultpage');
    if ~isempty(pages)
        page = pages(1);
        currentChilds = length(get(page, 'UserData'));
        if length(page) > 1
            for n = 2:length(pages)
                numChilds = length(get(pages(n), 'UserData'));
                if numChilds < currentChilds
                    page = pages(n);
                end
            end
        end
        userdata = get(page,'UserData');
        panel.isRegistered = true;
        if iscell(userdata)
            userdata{length(userdata)+1} = panel;
        else
            userdata{1} = panel;
        end
        set(page,'UserData',userdata);
    end
end
