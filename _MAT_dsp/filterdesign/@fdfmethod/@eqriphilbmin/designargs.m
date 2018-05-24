function args = designargs(this, hs)
%DESIGNARGS   Returns the inputs to the design function.

%   Author(s): P. Costa
%   Copyright 2005 The MathWorks, Inc.

dpass = convertmagunits(hs.Apass, 'db', 'linear', 'pass');

TWn = hs.TransitionWidth/2;

if strcmpi(this.FIRType,'4'),
    args = {{'minodd',51}, [TWn 1-TWn], [1 1],dpass,'hilbert'};
else
    args = {{'mineven',50}, [TWn 1-TWn], [1 1],dpass,'hilbert'};
end



% [EOF]
