function y = trigPower(blk, t, u) %#ok
%TRIGPOWER Detects when energy in u exceeds threshold
%   TRIGPOWER(BLK, T, U) Returns true when the power of U exceeds the
%   threshold of 1.1.
%
%   See also trigbegin, trigend, trigrearm.

%   Copyright 2007 The MathWorks, Inc.

y = (u'*u > 1.1);

% [EOF]
