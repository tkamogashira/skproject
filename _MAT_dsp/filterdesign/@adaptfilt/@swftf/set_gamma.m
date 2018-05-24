function g = set_gamma(h,g)
%SET_GAMMA Set the conversion factor.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


if length(g) ~= 2 ,
    error(message('dsp:adaptfilt:swftf:set_gamma:InvalidDimensions'));
end

% Always store as a row
g = g(:).';

