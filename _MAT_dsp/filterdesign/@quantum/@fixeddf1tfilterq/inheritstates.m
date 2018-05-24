function inheritstates(q,S)
%INHERITSTATES   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% S is a FILTSTATES.DFIIR containing FIs
q.privstatewl = max(S.Numerator.WordLength,S.Denominator.WordLength);
q.privnstatefl = S.Numerator.FractionLength;
q.privdstatefl = S.Denominator.FractionLength;

% [EOF]
