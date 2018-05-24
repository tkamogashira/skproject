function coefffl = set_coefffl(this, coefffl)
%SET_COEFFFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

if this.CoeffAutoScale
    error(siguddutils('readonlyerror', 'CoeffFracLength', 'CoeffAutoScale', false));
end

try
    this.privcoefffl = coefffl;
    updateinternalsettings(this);
catch 
    error(message('dsp:quantum:abstractfixedfarrowfdfilterq:set_coefffl:MustBeInteger'));
end


% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

coefffl = [];

% [EOF]
