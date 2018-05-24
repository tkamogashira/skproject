function args = designargs(this, hspecs)
%DESIGNARGS   Return the inputs for the design function.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

A = [convertmagunits(hspecs.Astop, 'db', 'linear', 'stop') ...
     convertmagunits(hspecs.Apass, 'db', 'linear', 'pass')];

args = {hspecs.FilterOrder, hspecs.Fpass, A, 'passedge', 'high'};

% [EOF]
