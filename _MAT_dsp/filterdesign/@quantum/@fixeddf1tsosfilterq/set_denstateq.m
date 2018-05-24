function [stWL stFL] = set_denstateq(q, accWL, accFL)
%SET_DENSTATEQ   Define denominator state format

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    stWL = q.privstatewl;
    if q.privStateAutoScale,
        % Avoid overflow when casting to State format
        nguardbits = 2;
        ideal_accWL = q.privmultwl + q.privcoeffwl + nguardbits;
        ideal_accFL = q.privmultfl + q.privcoefffl2;
        stFL = stWL - (min(accWL-accFL,ideal_accWL-ideal_accFL));
        q.privdstatefl = stFL;
    else
        stFL = q.privdstatefl;
    end
catch
end

% [EOF]
