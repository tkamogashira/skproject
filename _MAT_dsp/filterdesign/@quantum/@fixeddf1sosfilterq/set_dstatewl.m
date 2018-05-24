function dstatewl = set_dstatewl(this, dstatewl)
%SET_DSTATEWL   PreSet function for the 'DenStateWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.
%   Date: 2011/02/26 16:18:56 $

try
    this.privdstatewl = dstatewl;
catch
    error(message('dsp:quantum:fixeddf1sosfilterq:set_dstatewl:MustBePosInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event.
send_quantizestates(this);

% Store nothing to avoid duplication.
dstatewl = [];

% [EOF]
