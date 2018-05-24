function g = nominalgain(this)
%NOMINALGAIN   Nominal gain of a CICDECIM/CICINTERP filter.

%   Author(s): P. Costa
%   Copyright 2005 The MathWorks, Inc.

rcf = this.privRateChangeFactor;
idx = find(rcf == 1);

if length(idx) <= 1,
    rcf(idx) = [];
    R = rcf;
else
    R = 1;  % Handle the case when R = 1 (see g229761)
end

g = (R*this.DifferentialDelay)^this.NumberOfSections;

% [EOF]
