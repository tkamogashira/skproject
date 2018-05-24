function P = getposInUnits(h, Units, prefix);
% getposInUnits - get position of graphics object in specific units
%    getposInUnits(h, 'foo') returns the position of graphics object
%    associated with handle h in 'foo' units (e.g. 'pixels'). 
%    The 'units' property of h is only temporarily changed. At the end of
%    the query, it is reset to its original value.
%
%    getposInUnits(h, 'foo', 'outer') returns the outer position instead of
%    the position.
%
%    See also setposInUnits, GET.

if nargin<3,
    prefix = ''; % default: query 'position' property
end

u = get(h,'units');
set(h,'units', Units);
P = get(h,[prefix 'position']);
set(h,'units', u);


