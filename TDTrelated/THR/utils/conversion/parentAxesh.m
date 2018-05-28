function h=parentAxesh(h);
% parentAxesh - handle of parent axes
%   parentfigh(h) returns the handle of the axes to which the graphics
%   object having handle h belongs. Nan is returned if h does not have a
%   figure ancestor.
%
%   See also ANCESTOR, parentfigh.

if ~issinglehandle(h),
    error('Input argument h must be single graphics handle.')
end

h = ancestor(h,'axes');
if isempty(h), h = nan; end

