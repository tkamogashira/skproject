function outfl = set_outfl(this, outfl)
%SET_OUTFL   PreSet function for the 'OutputFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privoutfl = outfl;
catch
    error(message('dsp:quantum:fixeddf1filterq:set_outfl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing here to avoid duplication.
outfl = [];

% [EOF]
