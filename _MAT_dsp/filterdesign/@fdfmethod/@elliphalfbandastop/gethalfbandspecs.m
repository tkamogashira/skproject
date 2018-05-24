function [N,q,k] = gethalfbandspecs(this,specs)
%GETHALFBANDSPECS   Get the halfbandspecs.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

N = specs.FilterOrder;

rstopsquared = 10^(specs.Astop/10) - 1;

rpasssquared = 1/rstopsquared;
Apass = 10*log10(1+rpasssquared);

D = (rstopsquared)/(rpasssquared);

[q,k] = computeq2(this,N,D);


% [EOF]
