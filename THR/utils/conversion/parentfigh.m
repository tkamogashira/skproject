function h=parentfigh(h);
% parentfigh - handle of parent figure
%   parentfigh(h) returns the handle of the figure to which the graphics
%   object having handle h belongs. Nan is returned if h does not have a
%   figure ancestor.
%
%   See also ANCESTOR, parentAxesh.

if ~issinglehandle(h),
    error('Input argument h must be single graphics handle.')
end

h = ancestor(h,'figure');
if isempty(h), h = nan; end

