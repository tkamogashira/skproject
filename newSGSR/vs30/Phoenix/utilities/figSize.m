function figPos = figSize(figh, units);
% figsize - figure size in arbitrary units
%   figsize(h) returns size in points of figure with handle h.
%   h defaults to gcf.
%
%   figsize(h, 'foo') returns size in foo units.

if nargin<1, figh = gcf; end
if nargin<2, units = 'points'; end

% get figure size in points
figUnits = get(figh, 'units');
set(figh, 'units', units);
figPos = get(figh, 'position');
set(figh, 'units', figUnits);

figPos = figPos(3:4);
