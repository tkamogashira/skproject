function coefffl = set_coefffl(this, coefffl)
%SET_COEFFFL   PreSet function for the 'CoeffFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if this.CoeffAutoScale
    siguddutils('readonlyerror', 'CoeffFracLength', 'CoeffAutoScale', false);
end

try
    this.privcoefffl = coefffl;
catch 
    error(message('dsp:quantum:fixedscalarfilterq:set_coefffl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);
    
% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

% Store nothing to avoid duplication.
coefffl = [];

% [EOF]
