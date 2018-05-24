function b = trigend(hBlk, t, u) %#ok
%TRIGEND  Trigger when the data goes below 0.
%   TRIGEND(HBLK, T, U) Returns true when the data in U falls below 0.
%
%   See also trigbegin, trigrearm, trigPower.

%   Copyright 2007 The MathWorks, Inc.

if any(u < 0)
    b = true;
else
    b = false;
end

% [EOF]
