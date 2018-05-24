function [N,q,k] = gethalfbandspecs(this,specs)
%GETHALFBANDSPECS   Get the halfbandspecs.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


Fpass = 0.5-(specs.TransitionWidth)/2;

Wp = tan(pi*Fpass/2);

[q,k] = computeq(this,Wp);

rstopsquared = 10^(specs.Astop/10) - 1;
rpasssquared = 1/rstopsquared;
Apass = 10*log10(1+rpasssquared);
D = (rstopsquared)/(rpasssquared);

% Now determine order required
N = ceil(log10(16*D)/log10(1/q));
if rem(N,2) == 0,
    % Force odd order
    N = N + 1;
end
if N == 1,
    % Can't handle order this low
    N = 3;
end



% [EOF]
