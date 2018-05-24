function Snum = nullnumstate(q)
%NULLNUMSTATE   

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

Snum = fi(0,'Signed',true,'WordLength',q.StateWordLength,...
    'FractionLength',q.NumStateFracLength);

% [EOF]
