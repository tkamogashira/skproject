function stateautoscale = set_stateautoscale(q, stateautoscale)
%SET_STATEAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

q.privStateAutoScale = stateautoscale;

% Quantizer changed, send a quantizestates event
send_quantizestates(q);

% [EOF]
