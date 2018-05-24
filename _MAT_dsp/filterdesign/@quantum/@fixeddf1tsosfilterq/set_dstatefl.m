function dstatefl = set_dstatefl(this, dstatefl)
%SET_DSTATEFL   PreSet function for the 'DenStateFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if this.StateAutoScale
    siguddutils('readonlyerror', 'DenStateFracLength', 'StateAutoScale', false);
end

try
    this.privdstatefl = dstatefl;
catch
    error(message('dsp:quantum:fixeddf1tsosfilterq:set_dstatefl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
dstatefl = [];

% [EOF]
