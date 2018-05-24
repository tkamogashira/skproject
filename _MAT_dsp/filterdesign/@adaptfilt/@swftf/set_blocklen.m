function N = set_blocklen(h,N)
%SET_BLOCKLEN Set the block length.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');

if N < L,
    error(message('dsp:adaptfilt:swftf:set_blocklen:InvalidDimensions'));
end
