function stateautoscale = set_stateautoscale(this, stateautoscale)
%SET_STATEAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this.privStateAutoScale = stateautoscale;

updateinternalsettings(this);

% Quantizer changed, send a quantizestates event
send_quantizestates(this);

% [EOF]
