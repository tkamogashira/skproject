function FwdPrediction = set_fwd(h,FwdPrediction)
%SET_FWD Set the forward prediction coefficients and error.

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


if ~isstruct(FwdPrediction),
    error(message('dsp:adaptfilt:qrdlsl:set_fwd:InvalidParam'));
end

L = get(h,'FilterLength');

if length(FwdPrediction.Coeffs) ~= L,
    error(message('dsp:adaptfilt:qrdlsl:set_fwd:InvalidDimensions1'));
end

% Make sure coefficients are a row
FwdPrediction.Coeffs = FwdPrediction.Coeffs(:).';

if length(FwdPrediction.Error) ~= L,
    error(message('dsp:adaptfilt:qrdlsl:set_fwd:InvalidDimensions2'));
end

% Make sure error is a column
FwdPrediction.Error = FwdPrediction.Error(:);

if any(FwdPrediction.Error <= 0)
    error(message('dsp:adaptfilt:qrdlsl:set_fwd:MustBePositive'));
end
