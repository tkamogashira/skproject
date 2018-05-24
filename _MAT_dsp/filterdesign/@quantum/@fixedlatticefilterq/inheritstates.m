function inheritstates(q,S)
%INHERITSTATES   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% S is a FI
q.privstatewl = S.WordLength;
q.privstatefl = S.FractionLength;

% [EOF]
