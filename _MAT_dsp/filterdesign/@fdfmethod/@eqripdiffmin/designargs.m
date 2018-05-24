function args = designargs(this, hs)
%DESIGNARGS   Returns the inputs to the design function.

%   Author(s): P. Costa
%   Copyright 2005 The MathWorks, Inc.

dpass = convertmagunits(hs.Apass, 'db', 'linear', 'pass');

args = {{'minodd',51}, [0 1], [0 pi],dpass,'differentiator'};

% [EOF]
