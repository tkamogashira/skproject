function b = trigrearm(hBlk, t, u) %#ok
%TRIGREARM Trigger when the data goes above 0 if time > 1.
%   TRIGREARM(HBLK, T, U) returns true if T is greater than 1 and U is
%   greater than 0.
%
%   See also trigbegin, trigend, trigPower.

%   Copyright 2007 The MathWorks, Inc.

if t > 1 && any(u > 0)
    b = true;
else
    b = false;
end

% [EOF]
