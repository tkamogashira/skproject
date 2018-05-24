function fwd = set_fwd(h,fwd)
%SET_FWD Set the forward prediction Coefficients and error.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

if ~isstruct(fwd),
    error(message('dsp:adaptfilt:ftf:set_fwd:InvalidParam1'));
end

L = get(h,'FilterLength');

if length(fwd.Coeffs) ~= L,
    error(message('dsp:adaptfilt:ftf:set_fwd:InvalidDimensions'));
end

% Make sure coefficients are a row
fwd.Coeffs = fwd.Coeffs(:).';

if length(fwd.Error) ~= 1,
    error(message('dsp:adaptfilt:ftf:set_fwd:InvalidParam2'));
end

if fwd.Error < 0
    error(message('dsp:adaptfilt:ftf:set_fwd:MustBePositive'));
end

warnifreset(h, 'FwdPrediction');
