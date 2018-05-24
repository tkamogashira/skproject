function statefl = set_dstatefl(this, statefl)
%SET_DENSTATEFL   PreSet function for the 'DenStateFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if this.StateAutoScale
    siguddutils('readonlyerror', 'DenStateFracLength', 'StateAutoScale', false);
end

try
    this.privdstatefl = statefl;
catch
    error(message('dsp:quantum:fixeddf1tfilterq:set_dstatefl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
statefl = [];

% [EOF]
