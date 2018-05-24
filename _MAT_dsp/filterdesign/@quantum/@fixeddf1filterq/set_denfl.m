function denfl = set_denfl(this, denfl)
%SET_DENFL   PreSet function for the 'DenFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if this.CoeffAutoScale
    siguddutils('readonlyerror', 'DenFracLength', 'CoeffAutoScale', false);
end

try
    this.privcoefffl2 = denfl;
catch 
    error(message('dsp:quantum:fixeddf1filterq:set_denfl:MustBeInteger'));
end

% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

% Update the downstream automagic.
updateinternalsettings(this);

% Store nothing here to avoid duplication.
denfl = [];

% [EOF]
