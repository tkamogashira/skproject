function M = setdecim(Hm,M)
%SETDECIM Overloaded set for the DecimationFactor property.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

Hm.privRateChangeFactor = [1 M];

% Reset states amd polyphase matrix.
num = formnum(Hm,Hm.refpolym); % Don't use Hm.Numerator because we would
                               % loose the reference coefficients since the
                               % numerator is formed form the quantized
                               % (privpolym) rather than the reference
                               % (refpolym). See g226901 for more info.
if ~isempty(num),
    resetpolym(Hm,num);
end
reset(Hm);

thissetdecim(Hm,M);

set_ncoeffs(Hm.filterquantizer, naddp1(Hm));
set_nphases(Hm.filterquantizer, M);

% Clear metadata
clearmetadata(Hm);

M = []; % Make it "phantom"

% [EOF]
