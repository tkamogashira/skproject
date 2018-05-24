function p = set_fwdpwr(h,p)
%SET_FWDPWR Set the forward prediction error powers.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

L = get(h,'FilterLength');

if length(p) ~= L,
    error(message('dsp:adaptfilt:gal:set_fwdpwr:InvalidDimensions'));
end

% Always store as a column
p = p(:);

warnifreset(h,'FwdPredErrorPower');
