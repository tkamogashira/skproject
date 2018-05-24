function S = nullstate1(q)
%NULLSTATE1   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

S = fi(0,'Signed',true,'WordLength',q.StateWordLength,...
    'FractionLength',q.privstatefl);

% [EOF]
