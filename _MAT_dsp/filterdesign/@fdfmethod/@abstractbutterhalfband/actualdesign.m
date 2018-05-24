function varargout = actualdesign(this,specs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

N = getorder(this,specs);

if N == 1,
    error(message('dsp:fdfmethod:abstractbutterhalfband:actualdesign:InvalidRange'));
end

if rem(N,2) ~= 1,
    error(message('dsp:fdfmethod:abstractbutterhalfband:actualdesign:FilterErr'));
end
L = (N-1)/2;

J = floor(L/2);

j1 = (1:J)';

alpha1 = tan(pi*j1/N).^2;

j2 = (J+1:L)';

alpha0 = cot(pi*j2/N).^2;

varargout{1} = {alpha0,alpha1};


% [EOF]
