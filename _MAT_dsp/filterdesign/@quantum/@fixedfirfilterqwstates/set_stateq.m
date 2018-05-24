function [stWL stFL] = set_stateq(q, accWL, accFL)
%SET_STATEQ   Define state format

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    stWL = q.privstatewl;
    if q.privStateAutoScale,
        % Avoid overflow when casting to State format
        ideal_accWL = q.privinwl + q.privcoeffwl + nguardbits(q.ncoeffs-1);
        ideal_accFL = q.privinfl + q.privcoefffl;
        stFL = stWL - min(accWL-accFL,ideal_accWL-ideal_accFL);
        q.privstatefl = stFL;
    else
        stFL = q.privstatefl;
    end
catch
end

% [EOF]
