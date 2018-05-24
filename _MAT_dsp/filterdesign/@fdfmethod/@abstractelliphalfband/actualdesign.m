function alpha = actualdesign(this,specs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


[N,q,k] = gethalfbandspecs(this,specs);

if N == 1,
    error(message('dsp:fdfmethod:abstractelliphalfband:actualdesign:orderTooSmall'));
end

if rem(N,2) ~= 1,
    error(message('dsp:fdfmethod:abstractelliphalfband:actualdesign:evenOrder'));
end

[Omega,V] = computeOmega(this,N,q,k);

b = 2*V./(1+Omega.^2);

alpha = (2-b)./(2+b);


% [EOF]
