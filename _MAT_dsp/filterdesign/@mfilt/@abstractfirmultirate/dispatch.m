function Hd = dispatch(Hb)
%DISPATCH Returns DFILT for analysis.

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.


Hd = Hb.Filters;
Hbd = reffilter(Hb);
Hd.refnum = Hbd.Numerator; % Store reference coefficients
Hd.Numerator = Hb.Numerator;

% [EOF]
