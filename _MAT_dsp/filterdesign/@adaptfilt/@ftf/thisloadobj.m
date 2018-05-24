function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

lsl_thisloadobj(this, s);

set(this, ...
    'KalmanGain',       s.KalmanGain, ...
    'ConversionFactor', s.ConversionFactor, ...
    'KalmanGainStates', s.KalmanGainStates);

% [EOF]
