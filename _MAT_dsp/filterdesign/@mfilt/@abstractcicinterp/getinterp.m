function L = getinterp(Hm,dummy)
%GETINTERP Get the interpolation factor.

%   Author: R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.privRateChangeFactor;

L = R(1);
