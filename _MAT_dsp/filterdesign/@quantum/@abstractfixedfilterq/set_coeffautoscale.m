function coeffautoscale = set_coeffautoscale(this, coeffautoscale)
%SET_COEFFAUTOSCALE   PreSet Function for the Coefficient AutoScale.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Set the privCoeffAutoScale property before sending the quantizecoeff
% event
this.privCoeffAutoScale = coeffautoscale;

% Quantizer changed, send a quantizecoeffs event
send_quantizecoeffs(this);

% [EOF]
