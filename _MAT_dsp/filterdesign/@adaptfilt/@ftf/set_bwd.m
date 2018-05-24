function bwd = set_bwd(h,bwd)
%SET_BWD Set the backward prediction Coefficients and error.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

if ~isstruct(bwd),
    error(message('dsp:adaptfilt:ftf:set_bwd:InvalidParam1'));
end

L = get(h,'FilterLength');

if length(bwd.Coeffs) ~= L,
    error(message('dsp:adaptfilt:ftf:set_bwd:InvalidDimensions'));
end

% Make sure coefficients are a row
bwd.Coeffs = bwd.Coeffs(:).';

if length(bwd.Error) ~= 1,
    error(message('dsp:adaptfilt:ftf:set_bwd:InvalidParam2'));
end

if bwd.Error < 0
    error(message('dsp:adaptfilt:ftf:set_bwd:MustBePositive'));
end

warnifreset(h, 'BkwdPrediction');
