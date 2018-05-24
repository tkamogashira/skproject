function BkwdPrediction = set_bwd(h,BkwdPrediction)
%SET_BWD Set the backward prediction Coefficients and error.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


if ~isstruct(BkwdPrediction),
    error(message('dsp:adaptfilt:lsl:set_bwd:InvalidParam'));
end

L = get(h,'FilterLength');

if length(BkwdPrediction.Coeffs) ~= L-1,
    error(message('dsp:adaptfilt:lsl:set_bwd:InvalidDimensions1'));
end


% Make sure coefficients are a row
BkwdPrediction.Coeffs = BkwdPrediction.Coeffs(:).';

if length(BkwdPrediction.Error) ~= L,
    error(message('dsp:adaptfilt:lsl:set_bwd:InvalidDimensions2'));
end

% Make sure error is a column
BkwdPrediction.Error = BkwdPrediction.Error(:);

if any(BkwdPrediction.Error <=0)
    error(message('dsp:adaptfilt:lsl:set_bwd:MustBePositive'));
end

warnifreset(h,'BkwdPrediction');
