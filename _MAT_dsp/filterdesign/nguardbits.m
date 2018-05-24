function n = nguardbits(naccum)
%NGUARDBITS Compute the number of guard bits for an ideal accumulator
%   N = NGUARDBITS(NACCUM) returns the number of guard bits N necessary to 
%   add NACCUM+1 fixed-point numbers of the same format (i.e. accumulate
%   NACCUM times) without overflow nor underflow.
%
%   Example: 
%       %Number of guard bits that are necessary in the accumulator to
%       %implement a DFFIR filter with 128 coefficients:
%       n = nguardbits(127);  % returns n = 7;

%   Author(s): V. Pellissier
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(1,1,nargin,'struct'))
if naccum<0,
    error(message('dsp:nguardbits:MustBePositive'));
end
n = ceil(log2(naccum+1));

% [EOF]
