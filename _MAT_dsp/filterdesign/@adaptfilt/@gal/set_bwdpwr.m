function p = set_bwdpwr(h,p)
%SET_BWDPWR Set the backward prediction error powers.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');

if length(p) ~= L,
    error(message('dsp:adaptfilt:gal:set_bwdpwr:InvalidDimensions'));
end

% Always store as a column
p = p(:);

warnifreset(h,'BkwdPredErrorPower');
