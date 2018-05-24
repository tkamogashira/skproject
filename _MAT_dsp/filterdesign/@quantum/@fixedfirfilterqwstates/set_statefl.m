function statefl = set_statefl(this, statefl)
%SET_STATEFL   PreSet function for the 'StateFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if this.StateAutoScale
    siguddutils('readonlyerror', 'StateFracLength', 'StateAutoScale', false);
end

try
    this.privstatefl = statefl;
catch
    error(message('dsp:quantum:fixedfirfilterqwstates:set_statefl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
statefl = [];

% [EOF]
