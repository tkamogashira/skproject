function statewl = set_statewl(this, statewl)
%SET_STATEWL   PreSet function for the 'StateWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privstatewl = statewl;
catch
    error(message('dsp:quantum:fixedfirfilterqwstates:set_statewl:MustBePosInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
statewl = [];

% [EOF]
