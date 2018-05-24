function inheritstates(q,S)
%INHERITSTATES   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% S is a FILTSTATES.DFIIR containing FIs
q.privinwl = S.Numerator.WordLength;
q.privinfl = S.Numerator.FractionLength;
q.privoutwl = S.Denominator.WordLength;
q.privoutfl = S.Denominator.FractionLength;

% [EOF]
