function args = designargs(this, hspecs)
%DESIGNARGS   Return the arguments for the design method.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

A = [convertmagunits(hspecs.Astop, 'db', 'linear', 'stop') ...
    convertmagunits(hspecs.Apass, 'db', 'linear', 'pass')];

args = {hspecs.FilterOrder, hspecs.Fstop, A, 'stopedge', 'high'};

% [EOF]
