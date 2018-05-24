function b = trigbegin(hBlk, t, u) %#ok
%TRIGBEGIN Return true when the signal goes above 0.
%   TRIGBEGIN(HBLK, T, U) returns true when the data in U rises above 0.
%
%   See also trigrearm, trigend, trigPower.

%   Copyright 2007 The MathWorks, Inc.

if any(u > 0)
    b = true;
else
    b = false;
end

% [EOF]
