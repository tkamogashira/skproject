function nstatewl = set_nstatewl(this, nstatewl)
%SET_NSTATEWL   PreSet function for the 'nstatewl' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privnstatewl = nstatewl;
catch
    error(message('dsp:quantum:fixeddf1sosfilterq:set_nstatewl:MustBePosInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
nstatewl = [];

% [EOF]
