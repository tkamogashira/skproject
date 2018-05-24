function dstatefl = set_dstatefl(this, dstatefl)
%SET_DSTATEFL   PreSet function for the 'dstatefl' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privdstatefl = dstatefl;
catch
    error(message('dsp:quantum:fixeddf1sosfilterq:set_dstatefl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
dstatefl = [];

% [EOF]
