function nstatefl = set_nstatefl(this, nstatefl)
%SET_NSTATEFL   PreSet function for the 'NumStateFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if this.StateAutoScale
    siguddutils('readonlyerror', 'NumStateFracLength', 'StateAutoScale', false);
end

try
    this.privnstatefl = nstatefl;
catch
    error(message('dsp:quantum:fixeddf1tsosfilterq:set_nstatefl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
nstatefl = [];

% [EOF]
