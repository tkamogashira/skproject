function denfl = set_denfl(this, denfl)
%SET_DENFL   PreSet Function for the 'DenFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if this.CoeffAutoScale
    siguddutils('readonlyerror', 'DenFracLength', 'CoeffAutoScale', false);
end

try
    this.privcoefffl2 = denfl;
catch 
    error(message('dsp:quantum:abstractfixediirfilterq:set_denfl:MustBeInteger'));
end

% Update any downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

% Store nothing here to avoid duplication.
denfl = [];

% [EOF]
