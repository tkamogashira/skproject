function len = allocate(Hm,lx,offset)
%ALLOCATE   Determine the correct output length based on input length, rate
%change factors, and input offset.
%
%   lx - Input length (per channel)

%   Author(s): V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

R = Hm.privRateChangeFactor;

L = R(1); M = R(2);

len = L*ceil((lx -(mod((M-mod(offset,M)),M)))/M);

% [EOF]
