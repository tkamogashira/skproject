function s = set_gstates(h,s)
%SET_GSTATES Set the Kalman gain States.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');

if length(s) ~= L,
    error(message('dsp:adaptfilt:ftf:set_gstates:InvalidDimensions'));
end

% Always store as a column
s = s(:);

warnifreset(h, 'KalmanGainStates');
