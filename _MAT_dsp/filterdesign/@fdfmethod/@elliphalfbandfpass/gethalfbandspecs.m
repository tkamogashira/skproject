function [N,q,k] = gethalfbandspecs(this,specs)
%GETHALFBANDSPECS   Get the halfbandspecs.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

N = specs.FilterOrder;

Fpass = 0.5-(specs.TransitionWidth)/2;

Wp = tan(pi*Fpass/2);

[q,k] = computeq(this,Wp);

% [EOF]
