function w = set_weights(this, w)
%SET_WEIGHTS   PreSet function for weights properties.

%   Author(s): V. Pellissier
%   Copyright 2005-2011 The MathWorks, Inc.

w = w(:).'; % Force row
if length(w)==1,
    w = [w w];
end

if length(w)~=2,
    error(message('dsp:fdfmethod:abstractlpnorm:set_weights:InvalidInput1'));
end

if (any(w <= 0))
    error (message('dsp:fdfmethod:abstractlpnorm:set_weights:InvalidInput2'));
end
if ~all(isfinite(w))
    error(message('dsp:fdfmethod:abstractlpnorm:set_weights:InvalidInput3'));
end

% [EOF]
