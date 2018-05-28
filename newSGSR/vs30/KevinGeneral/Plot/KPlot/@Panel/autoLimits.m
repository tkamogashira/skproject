function panel = autoLimits(panel, xMargin, yMargin, strNoRedraw)
% AUTOLIMITS automatically set the X and Y limits of the Panel
%
% panel = autoLimits(Panel panel, xMargin, yMargin) 
% Sets the axes limits for the panel object
%     
%      panel : A Panel instance we want to add a textBox object to
%    xMargin : The extra space being left at the data extremities
%    yMargin : The extra space being left at the data extremities
%
% Returns: panel, with textBox added to it.
% 
% Example: 
%  >> panel = autoLimits(panel, 0, 0); % no margins

% Created by: Kevin Spiritus

%---------------- CHANGELOG -----------------------
% 06/12/2010    Abel            Bugfix: xlimits(1)/xlimits(2) can't have the same value 

%% Check params
if ~isequal(3, nargin) && ~isequal(4, nargin)
    error('autoLimits takes three arguments.');
end

noRedraw = 0;
if isequal(4, nargin)
    if ~isequal('noredraw', lower(strNoRedraw))
        error('Fourth argument can only be ''noredraw''.');
    else
        noRedraw = 1;
    end
end

xLimits = [+inf, -inf];
yLimits = [+inf, -inf];
for cPlotObject = 1:length(panel.plotObjects)
    limits = getDataLimits(panel.plotObjects{cPlotObject});
    xLimits(1) = min([xLimits(1) limits(1,1)]);
    xLimits(2) = max([xLimits(2) limits(1,2)]);
    yLimits(1) = min([0 yLimits(1) limits(2,1)]);
    yLimits(2) = max([yLimits(2) limits(2,2)]);
end

% apply margins
if xLimits(1) < 0
    xLimits(1) = xLimits(1) * (1 + xMargin);
else
    xLimits(1) = xLimits(1) * (1 - xMargin);
end

if xLimits(2) < 0
    xLimits(2) = xLimits(2) * (1 - xMargin);
else
    xLimits(2) = xLimits(2) * (1 + xMargin);
end

if yLimits(1) < 0
    yLimits(1) = yLimits(1) * (1 + yMargin);
else
    yLimits(1) = yLimits(1) * (1 - yMargin);
end

if yLimits(2) < 0
    yLimits(2) = yLimits(2) * (1 - yMargin);
else
    yLimits(2) = yLimits(2) * (1 + yMargin);
end


if ~noRedraw
    panel = set(panel, 'xlim', [xLimits(1) xLimits(2)]);
    panel = set(panel, 'ylim', [yLimits(1) yLimits(2)]);
else
    panel = set(panel, 'xlim', [xLimits(1) xLimits(2)], 'noredraw');
    panel = set(panel, 'ylim', [yLimits(1) yLimits(2)], 'noredraw');
end

%by Abel: xlimits(1)/xlimits(2) can't have the same value 
if (panel.params.xlim(1) == panel.params.xlim(2))
    panel.params.xlim = [panel.params.xlim(1)-1, panel.params.xlim(1)+1];
end