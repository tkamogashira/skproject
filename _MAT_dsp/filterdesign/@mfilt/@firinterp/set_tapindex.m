function tapindex = set_tapindex(H, tapindex)
%SET_TAPINDEX   PreSet function for the 'tapindex' property.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Make sure tap index is set as a uint32
tapindex = uint32(tapindex);


% [EOF]
