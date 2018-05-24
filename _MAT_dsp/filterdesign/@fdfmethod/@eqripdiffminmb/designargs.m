function args = designargs(this, hs)
%DESIGNARGS   Returns the inputs to the design function.

%   Author(s): P. Costa
%   Copyright 2005 The MathWorks, Inc.

if (hs.Fpass == 1),
    % Must be desiging a type IV differentiator revert to 'Ap' spec
    hs.Fstop = NaN; % Ignore stopband caracteristics
    hs.Astop = NaN;
    hs = fspecs.diffmin(hs.Apass);
    switchspec = fdfmethod.eqripdiffmin;
    args = designargs(switchspec, hs);
else
    dpass = convertmagunits(hs.Apass, 'db', 'linear', 'pass');
    dstop   = convertmagunits(hs.Astop, 'db', 'linear', 'stop');
    % Must be desiging a type III differentiator
    order = {'mineven',50};
    F = [0 hs.Fpass hs.Fstop 1];
    A = [0 hs.Fpass*pi 0  0];
    R = [dpass dstop];
    args = {order,F,A,R,'differentiator'};
end


% [EOF]
