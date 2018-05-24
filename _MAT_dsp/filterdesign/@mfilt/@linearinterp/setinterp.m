function L = setinterp(Hm,L)
%SETINTERP Overloaded set for the InterpolationFactor property.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

Hm.privRateChangeFactor = [L 1];

% Reset states and polyphase matrix.
reset(Hm);
num = [1-abs([-L+1:L-1]/L)];

% Clear any possible fdesign/fmethod objects associated with this filter
% since coefficients are being changed
setfdesign(Hm, []);
setfmethod(Hm, []);

% Update the Numerator property of the contained object.
Hm.Filters = lwdfilt.symfir(num);

% Reset the polyphase matrix
resetpolym(Hm,num);

% Set number of coefficients
Hm.ncoeffs = length(num);

set_ncoeffs(Hm.filterquantizer, naddp1(Hm));

L = [];

% [EOF]
