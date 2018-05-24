function n = thisnstates(Hm)
%NSTATES  Number of states in an FIR Fractional Interpolation filter.
%   NSTATES(Hm) returns the number of states in the FIR Fractional
%   Interpolation discrete-time filter Hm.  The number of states depends on
%   the filter structure and the coefficients.
  
%   Author: A. Charry
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.RateChangeFactors;
L = R(1); M = R(2);

P = Hm.PolyphaseDelays;
if isempty(P),
    l0 = 1;
    m0 = 1;
else
    l0 = P(2);
    m0 = P(1);
end

nbinterp = ceil(Hm.ncoeffs/M);
filtBufSize = M*(ceil(nbinterp/L)-1);

inBufSize = l0*(M-1);
outBufSize = m0*(M-1);

n  = inBufSize + filtBufSize + outBufSize;

% [EOF]
