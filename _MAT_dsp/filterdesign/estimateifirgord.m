function N = estimateifirgord(L,F,DEV)
%ESTIMATEIFIRGORD   Estimate order of 'g' filter used in IFIR.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

tempArg1 = 1./acosh(acoshArg(F(2),2./L - (F(2)+2.*F(3))./3));

tempArg2 = .5.*L./acosh(acoshArg(L.*F(2)./2,1 - L.*(F(2)+2.*F(3))./6));

N = ceil(acosh(1./DEV(2)).*(tempArg1+tempArg2));

%-------------------------------------------------------------------
function arg = acoshArg(w1,w2)

arg = (2.*cos(w1.*pi) - cos(w2.*pi) + 1)./(1 + cos(w2.*pi));

% [EOF]
