function setposInUnits(h, Units, Pos);
% setposInUnits - set position of graphics object in specific units
%    setposInUnits(h, 'foo', Pos) sets the position of graphics object
%    associated with handle h to Pos as specified in 'foo' units 
%    (e.g. 'pixels'). The 'units' property of h is only temporarily 
%    changed. At the end of the call, it is reset to its original value.
%
%    See also getposInUnits, SET.

u = get(h,'units');
set(h,'units', Units);
set(h, 'position', Pos);
set(h,'units', u);


