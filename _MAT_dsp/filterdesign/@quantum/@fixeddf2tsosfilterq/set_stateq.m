function [stWL stFL] = set_stateq(q, accWL, accFL)
%SET_STATEQ   Define state format

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    stWL = q.privstatewl;
    if q.privStateAutoScale,
        % Avoid overflow when casting to State format
        nguardbits = 2;
        ideal_nintbits = q.privstageinwl + q.privcoeffwl + nguardbits - (q.privstageinfl + q.privcoefffl);
        ideal_dintbits = q.privstageoutwl + q.privcoeffwl + nguardbits - (q.privstageoutfl + q.privcoefffl2);
        stFL = stWL - min(accWL-accFL,max(ideal_nintbits,ideal_dintbits));
        q.privstatefl = stFL;
    else
        stFL = q.privstatefl;
    end
catch
end

% [EOF]
