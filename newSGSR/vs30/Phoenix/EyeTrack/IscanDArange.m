function IscanDArange(maxVal, DAoffset);
% IscanDArange - set DA range for ISCAN monitoring
%   IscanDArange(V) sets the range of DA-out Voltages of the Iscan
%   to V Volt.
%
%   IscanDArange(V, [x y]) also sets offset to x,y.

if nargin<1, % show current settings
   eyedisplay showDArange
   return
end
if nargin<2, DAoffset=[0 0];
else,
   if ~isequal(2, length(DAoffset)),
      error('Offset must be 2-element vector [x,y].');
   end
end

eyedisplay('maxrange', [], maxVal, DAoffset);


