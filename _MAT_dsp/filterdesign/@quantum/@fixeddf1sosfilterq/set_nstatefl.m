function nstatefl = set_nstatefl(this, nstatefl)
%SET_NSTATEFL   PreSet function for the 'NumStateFracLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privnstatefl = nstatefl;
catch
    error(message('dsp:quantum:fixeddf1sosfilterq:set_nstatefl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Avoid the downstream automagic.
nstatefl = [];

% [EOF]
