function quantizeacc(h,eventData)
%QUANTIZEACC Quantize PolyphaseAccum   

%   Author(s): V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

w = warning('off');
[wid, wstr] = lastwarn;

try
    h.PolyphaseAccum = quantizeacc(h.filterquantizer,h.PolyphaseAccum);
catch
    % NO OP
end

warning(w);
lastwarn(wid, wstr);

% [EOF]
