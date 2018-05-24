function quantizecoeffs(h,eventData)
% Quantize coefficients


%   Author(s): R. Losada
%   Copyright 1988-2005 The MathWorks, Inc.

if isempty(h.refpolym)
    return;
end

% Quantize the coefficients
h.privpolym = quantizecoeffs(h.filterquantizer,h.refpolym);

setmaxprod(h.filterquantizer, h);
setmaxsum(h.filterquantizer, h);

% [EOF]
