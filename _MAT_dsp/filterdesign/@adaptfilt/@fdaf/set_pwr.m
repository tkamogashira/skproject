function p = set_pwr(h,p)
%SET_PWR Set the Power of FFT input signals.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


L = get(h,'FilterLength');
N = get(h,'BlockLength');

if length(p) ~= N+L,
    error(message('dsp:adaptfilt:fdaf:set_pwr:InvalidDimensions'));
end

if any(p < 0),
    error(message('dsp:adaptfilt:fdaf:set_pwr:MustBePositive'));
end

% Always store as a column
p = p(:);

warnifreset(h,'Power');

