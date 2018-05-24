function stateautoscale = set_stateautoscale(this, stateautoscale)
%SET_STATEAUTOSCALE   PreSet function for the 'StateAutoScale' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this.privStateAutoScale = stateautoscale;

% Update the downstream automagic.
updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% Store nothing to avoid duplication.
stateautoscale = [];

% [EOF]
