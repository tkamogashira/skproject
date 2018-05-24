function len = allocate(Hm,lx,offset)
%ALLOCATE   Determine the correct output length based on input length, rate
%change factors, and input offset.
%
%   lx - Input length (per channel)

%   Author(s): R. Losada
%   Copyright 1988-2004 The MathWorks, Inc.

R = Hm.privRateChangeFactor;

L = R(1); M = R(2);

len = ceil((L*lx -(mod((M-mod(L*offset,M)),M)))/M);

% [EOF]
