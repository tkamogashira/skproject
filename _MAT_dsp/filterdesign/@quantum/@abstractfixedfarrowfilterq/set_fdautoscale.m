function fdautoscale = set_fdautoscale(this, fdautoscale)
%SET_FDAUTOSCALE   PreSet function for the 'fdautoscale' property.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

this.privfdautoscale = fdautoscale;

send(this,'quantizefracdelay');


% [EOF]
