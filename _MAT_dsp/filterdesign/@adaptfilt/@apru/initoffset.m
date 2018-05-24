function initoffset(h,Offset)
%INITOFFSET  Initialize the Offset.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin < 2,
    Offset = 0.05;
end

po = get(h,'ProjectionOrder');
P = 1/Offset*eye(po);

set(h,'InvOffsetCov',P);

