function statefl = set_nstatefl(this, statefl)
%SET_NUMSTATEFL   PreSet function for the 'NumStateFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if this.StateAutoScale
    siguddutils('readonlyerror', 'NumStateFracLength', 'StateAutoScale', false);
end

try
    this.privnstatefl = statefl;
catch
    error(message('dsp:quantum:fixeddf1tfilterq:set_nstatefl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
statefl = [];

% [EOF]
