function Sden = nulldenstate(q)
%NULLDENSTATE   

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

Sden = fi(0,'Signed',true,'WordLength',q.StateWordLength,...
    'FractionLength',q.DenStateFracLength);

% [EOF]
