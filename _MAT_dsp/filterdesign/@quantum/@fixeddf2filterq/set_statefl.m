function statefl = set_statefl(this, statefl)
%SET_STATEFL   PreSet function for the 'StateFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privstatefl = statefl;
catch
    error(message('dsp:quantum:fixeddf2filterq:set_statefl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Don't store again.
state_fl = [];

% [EOF]
