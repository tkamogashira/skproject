function statewl = set_statewl(this, statewl)
%SET_STATEWL   PreSet function for the 'statewl' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privStatewl = statewl;
catch
    error(message('dsp:quantum:fixeddf1tfilterq:set_statewl:MustBePosInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
statewl = [];

% [EOF]
