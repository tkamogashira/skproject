function [stWL stFL] = set_numstateq(q, accWL, accFL)
%SET_NUMSTATEQ   Define numerator state format

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    stWL = q.privstatewl;
    if q.privStateAutoScale,
        % Avoid overflow when casting to State format
        nguardbits = 2;
        ideal_accWL = q.privmultwl + q.privcoeffwl + nguardbits;
        ideal_accFL = q.privmultfl + q.privcoefffl;
        stFL = stWL - (min(accWL-accFL,ideal_accWL-ideal_accFL));
        q.privnstatefl = stFL;
    else
        stFL = q.privnstatefl;
    end
catch
end

% [EOF]
