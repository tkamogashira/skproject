function s = set_fftstates(h,s)
%SET_FFTSTATES Set the FFTStates.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));


L = get(h,'FilterLength');
N = get(h,'BlockLength');

if (size(s,1) ~= 2*N) | (size(s,2) ~= L/N-1),
    error(message('dsp:adaptfilt:pbfdaf:set_fftstates:InvalidDimensions'));
end


warnifreset(h,'FFTStates');
