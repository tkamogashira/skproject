function c = set_rcoeffs(h,c)
%SET_RCOEFFS Set the reflection coefficients.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');

if length(c) ~= L-1,
    error(message('dsp:adaptfilt:gal:set_rcoeffs:InvalidDimensions'));
end

% Always store as a row
c = c(:).';

warnifreset(h,'ReflectionCoeffs');
