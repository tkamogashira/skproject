function n = thisnstates(Hm)
%NSTATES  Number of states in an FIR Fractional Decimation filter.
%   NSTATES(Hm) returns the number of states in the FIR Fractional
%   Decimation discrete-time filter Hm.  The number of states depends on
%   the filter structure and the coefficients.
%
%   See also DFILT.   
  
%   Author: P. Pacheco
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.RateChangeFactors;
L = R(1); M = R(2);

% Calculate number of states.
Lh = ceil(Hm.nCoeffs/(L*M));    % Length of polyphase sub-filter.
nfiltStates = M*(Lh-1);         % Each filter has Lh-1 states

P = Hm.PolyphaseDelays;
if isempty(P),
    l0 = 1;
    m0 = 1;
else
    l0 = P(1);
    m0 = P(2);
end

% Total states = input + filter + output states.
n  =  (L-1)*l0 + nfiltStates + (L-1)*m0; 

% [EOF]
