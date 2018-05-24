function statefl = set_statefl(this, statefl)
%SET_STATEFL   PreSet function for the 'StateFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privstatefl = statefl;
catch
    error(message('dsp:quantum:fixedlatticefilterq:set_statefl:MustBeInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
statefl = [];

% [EOF]
