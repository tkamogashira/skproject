function specs = getdesignspecs(this,hs)
%GETDESIGNSPECS   Get specs needed for actual design

%   Copyright 2008 The MathWorks, Inc.

Ag=10^(hs.G0/40);
specs.S = inv((((1/hs.Qa^2)-2)/(Ag+1/Ag) ) + 1);

% [EOF]
