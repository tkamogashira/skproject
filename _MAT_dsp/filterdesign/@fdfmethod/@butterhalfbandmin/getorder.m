function N = getorder(this,specs)
%GETORDER   Get the order.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

% Compute Apass from Astop (given that it is a halfband)
rstopsquared = 10^(specs.Astop/10) - 1;
rpasssquared = 1/rstopsquared;
Apass = 10*log10(1+rpasssquared);

Fpass = 0.5 - specs.TransitionWidth/2;

N = buttord(Fpass,1-Fpass,Apass,specs.Astop);
if rem(N,2) == 0,
    % Force odd order
    N = N + 1;
end


% [EOF]
