function [stWL stFL] = set_stateq(q, accWL, accFL)
%SET_STATEQ   Define state format

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    stWL = q.privstatewl;
    if q.privStateAutoScale,
        
        if length(q.ncoeffs) == 1
            q.ncoeffs = [1 1];
        end
        
        % Avoid overflow when casting to State format
        bits2add = nguardbits(sum(q.ncoeffs)-2);
        nprodintbits = q.privinwl+q.privcoeffwl-q.privinfl-q.privcoefffl;
        dprodintbits = q.privoutwl+q.privcoeffwl-q.privoutfl-q.privcoefffl2;
        ideal_accintbits = max(nprodintbits,dprodintbits) + bits2add;
        stFL = stWL - min(accWL-accFL,ideal_accintbits);
        q.privstatefl = stFL;
    else
        stFL = q.privstatefl;
    end
catch
end

% [EOF]
