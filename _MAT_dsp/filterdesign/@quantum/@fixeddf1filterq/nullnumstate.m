function Snum = nullnumstate(q)
%NULLNUMSTATE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

Snum = fi(0,'Signed',true,'WordLength',q.InputWordLength,...
    'FractionLength',q.InputFracLength);

% [EOF]
