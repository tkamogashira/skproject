function args = designargs(this, hs)
%DESIGNARGS   Return the design arguments for FIRNYQUIST.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

tw = hs.TransitionWidth;
if ~hs.NormalizedFrequency, 
    tw = tw/(hs.Fs/2);
end

L     = hs.Band;
R     = tw*L/2;
Astop = 10^(-hs.Astop/20);

args = { ...
    'minorder', ...
    L, ...
    R, ...
    Astop};

% [EOF]
