function g = set_kalmangain(h,g)
%SET_KALMANGAIN Set the Kalman gain matrix.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


L = get(h,'FilterLength');
if size(g,1) ~= L | size(g,2) ~= 2,
    error(message('dsp:set_kalmangain:invalidKalmanGain'));
end


