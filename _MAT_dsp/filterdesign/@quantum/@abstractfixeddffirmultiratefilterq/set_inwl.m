function inwl = set_inwl(this, inwl)
%SET_INWL   PreSet function for the 'InputWordLength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privinwl = inwl;
catch
    error(message('dsp:quantum:abstractfixeddffirmultiratefilterq:set_inwl:MustBePosInteger'));
end

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Update the downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
inwl = [];

% [EOF]
