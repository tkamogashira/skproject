function signed = set_signed(q, signed)
%SET_SIGNED   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

try
    q.privsigned = signed;
catch
    error(message('dsp:quantum:abstractfixedfarrowfdfilterq:set_signed:MustBeLogical'));
end

% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(q);


% [EOF]
