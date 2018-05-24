function M = getdecim(Hm,dummy)
%GETDECIM Get the decimation factor.

%   Author: R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

R = Hm.privRateChangeFactor;

M = R(2);
