function args = designargs(this, hspecs)
%DESIGNARGS   Return the inputs for the design method.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

A = [convertmagunits(hspecs.Apass, 'db', 'linear', 'pass') ...
    convertmagunits(hspecs.Astop, 'db', 'linear', 'stop')];

args = {hspecs.FilterOrder, hspecs.Fpass, A, 'passedge'};

% [EOF]
