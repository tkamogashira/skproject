function statewl = set_statewl(this, statewl)
%SET_STATEWL   PreSet function for the 'StateWordLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privStatewl = statewl;
catch
    error(message('dsp:quantum:fixeddf2filterq:set_statewl:MustBePosInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Avoid duplicate storage.
statewl = [];

% [EOF]
