function infl = set_infl(this, infl)
%SET_INFL   PreSet function for the 'InputFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.

try
    this.privinfl = infl;
catch
    error(message('dsp:quantum:abstractfixedfarrowfilterq:set_infl:MustBeInteger'));
end

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Update the downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
infl = [];

% [EOF]
