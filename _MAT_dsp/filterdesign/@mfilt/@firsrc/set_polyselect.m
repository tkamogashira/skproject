function polyselect = set_polyselect(H, polyselect)
%SET_POLYSELECT   PreSet function for the 'polyselect' property.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Make sure to cast to uint32, since the mex expects this.
polyselect = uint32(polyselect);

% [EOF]
