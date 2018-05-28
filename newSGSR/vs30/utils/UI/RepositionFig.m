function RepositionFig(figh)
% RepositionFig - bring figure back in visible range
%   Reposition figure if it falls off the screen by setting the position to 
%   the highest & rightmost value that will not result in losing the menubar.
%   Note: resizefunction are suppressed.

% store settings
screensize = get(0,'screensize');
screenunits = get(0,'units');
figunits = get(figh,'units');
figresize = get(figh,'ResizeFcn');
% temporary settings
set(0,'units', 'pixels');
set(figh,'units', 'pixels');
set(figh,'ResizeFcn', '');

figpos = get(figh,'position');
figpos(1) = Clip(figpos(1), 100-figpos(3), screensize(3)-100);
figpos(2) = Clip(figpos(2), 1-figpos(4), screensize(4)-figpos(4)-60);
% figpos, set(figh, 'vis','on'), pause
set(figh, 'position', figpos);

% restore originals
set(0,'units', screenunits);
set(figh,'units', figunits);
set(figh,'ResizeFcn', figresize);

