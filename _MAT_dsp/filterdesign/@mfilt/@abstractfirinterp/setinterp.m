function L = setinterp(Hm,L)
%SETINTERP Overloaded set for the InterpolationFactor property.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

Hm.privRateChangeFactor = [L 1];

% Reset states and polyphase matrix.
reset(Hm);
num = formnum(Hm,Hm.refpolym); % Don't use Hm.Numerator because we would
                               % loose the reference coefficients since the
                               % numerator is formed form the quantized
                               % (privpolym) rather than the reference
                               % (refpolym). See g226901 for more info.
resetpolym(Hm,num);

set_ncoeffs(Hm.filterquantizer, naddp1(Hm));
set_nphases(Hm.filterquantizer, L);

% Clear metadata
clearmetadata(Hm);

L = [];

% [EOF]
