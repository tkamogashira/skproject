function s = set_gstates(h,s)
%SET_GSTATES Set the Kalman gain States.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');
N = get(h,'BlockLength');
if length(s) ~= L+N-1,
    error(message('dsp:adaptfilt:swftf:set_gstates:InvalidDimensions'));
end

% Always store as a column
s = s(:);

warnifreset(h, 'KalmanGainStates');
